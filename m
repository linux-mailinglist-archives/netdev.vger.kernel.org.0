Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF19C444902
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhKCTg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:36:27 -0400
Received: from mail-dm6nam10on2085.outbound.protection.outlook.com ([40.107.93.85]:56516
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229918AbhKCTgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 15:36:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIA0E6R+9P2DXLi5wN3ziqFqjJ7q4s/kVzyZFGIIsnict/EprmTlA+xOTg949nw6ooLJPlvVZB6I5lhMvFrN37BiCL7FwW6QYxB/8h03NgsfnBdtyYuwazHLbI0wpV/uwxSJc/18PXIN31RjJRxeYeLj2uCOtqdRRvei158EXEFy5KuWa/Cr6eeZqG8/14IPw5tsVcQ8IZBc81W78XgSW3jS84FJPKYTnTH1UP2QV0aYMBzPKZK2FSU7+idR7P1JZpp/EgDYVPitMW9I3raYg+2KY+Egi4pfJSWYN3W7B6X8A5WAPXh0aPOYodqX2onhnnBB2B5BEsj720jLj7dCmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GLP3G1ju3lyeFHU++EpYjg/qLInmgCI/fmzysW7bp4=;
 b=QAStst6VWHzcYdiSa7F7nbzROqSrvqIuqQPM5yWqPo7/qMLfPrsyyIBRQqqfDiPOaEKPOd55RKvaK308wl5/R58xiei0eRFvvvyqHqvvjfrfqeDdWJwfr+SqEAE5COkOiTok53NZ4ITVxPrMKjcxlaUZULXRMBHWuMb9VHBGyVGAiRMWRjYzG7pA8DRSILdHhjds4C/WUbigyNh8wHVEXlLyrQH+Wew9YoVsmBb7B58bGTGl3AmDt7gAWi5P4TvjGzQnVfdfYCvsYtFr76Yp2s/e58FlO1Tir0P1f9G/+0n5EBUkxYvws3/LNN6VslStvWRaNV1GS26wwMP+bzKW2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GLP3G1ju3lyeFHU++EpYjg/qLInmgCI/fmzysW7bp4=;
 b=Sn7SmHroW3rIlEw3+qPqno7EgwYBadZoVTbvqXGJ/huO7YoW4Pd4kUxbaLRujHClTWDDI2FUfOifDvhh3qrne6/dOAo7V8CCZ0HDl6eIT0gsp+o2oFogjRKd4BCzaOPX2wBSD4PuQrzLx+pQhEEkz9WB0Cfzq/JSHqZX5w0c8GGVycgkh2Eh+mxeRVfQblABFw4ups6eH0l+nz/ZbJaMYGFU1/TM9pqZ+qUNZ1087IvBuywD3OjsFjX3kxC0ZrU3X93ti3J5MsIH0iuVS8SiyRsWlqvQHEDTQRurMoXfmbp/HiM6xzwJs5MpwLhFMXFpcfhjEMR0lLCygLmzYWov4g==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3351.namprd12.prod.outlook.com (2603:10b6:a03:de::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Wed, 3 Nov
 2021 19:33:44 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4669.011; Wed, 3 Nov 2021
 19:33:44 +0000
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
Thread-Index: AQHX0HsOgmPt0SHW2Em726F6lktfIqvxXxuAgADTWoA=
Date:   Wed, 3 Nov 2021 19:33:44 +0000
Message-ID: <516980ded04bc0db4594c3e81664e14d0e3fcbb8.camel@nvidia.com>
References: <20211103062111.3286-1-hanyihao@vivo.com>
         <bb52fc1b-4e95-bc5e-6aa9-82b9b35967cf@nvidia.com>
In-Reply-To: <bb52fc1b-4e95-bc5e-6aa9-82b9b35967cf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2be1ed0-7f76-464d-eb0c-08d99f00d96f
x-ms-traffictypediagnostic: BYAPR12MB3351:
x-microsoft-antispam-prvs: <BYAPR12MB335132685918B9977366E1C9B38C9@BYAPR12MB3351.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qOSww03WhVYDtEbCUpGdjMQ3Wksz/0h9efLQSU2l4WCL1vhtsUZ/j26I5hXn7tQbuYSCQEFFE0OFmCZR+Gt9iyrTabjj1nG9QEjRsUc5ML5wBqUm5NgH3Uu+zxSoAG5KNXjVa92d1axkIL0X6XkFIQs//RQm+pSJ9DWBcdWMnqwWhUR9cYcf2d4bTdIXMqpCaju7PTspuBykLH7LGNhoZ55XZg5BiKIQMXLOJ/5qC9LRhOFB+DNHB3UtYePHYsQcCZAcBtyLzrnVYCztsebRIGcNG9uAhE7ZRncrZBIrmwy6pOxBbyZ6yZpowPYpkZOg/1+EDdGLKOh3LGKkacriOuGLi/dErXPyAFaAWYZHmI9mPQor3+pl1VTHHKNQglXkhSATwlkr+zKfX2m+luP3j705L7r4ug5LwzqHnOOZq1IskFdAaELWkQDPsl71G+p/svYkZhoXfEf1DHCNvgONlGpsw8vn4fksKxeX6trbWxtXeeP6ZiF7DIvPK51qv1x7TcXF+K8koqXtRLy4fxDfrHj1jatBdtMlWU9LVk1VVr8DdHb9EGNLyz/AgEuHTChDz07yIvJesb0e9zipj/9P4zGg7by+5RqeeO5KfGBT4LnJG7wDNoxk4jxA0Hp3NSr02yVa9oQiJVQ1I5crSz+NJDcdk0UTUbCPjFO6Y2WWaJ4SivZ2gpdFoL2pn9ofOeQ+ONQFoaUQM8UssBe1jYXStWx+P3rgyb+jj1udEXCCD+8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66446008)(76116006)(64756008)(66556008)(508600001)(4326008)(86362001)(6486002)(66946007)(66476007)(2616005)(38100700002)(83380400001)(6512007)(26005)(38070700005)(110136005)(122000001)(6636002)(316002)(186003)(8936002)(8676002)(53546011)(2906002)(6506007)(5660300002)(921005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STBYT040OURhZVVGc05VRmJRZ0NaSmFZYkFyY09Zb1c0RkxVVkZyWFZVMlRQ?=
 =?utf-8?B?L1lYZGRyc2tQc2o1UW00WGorYUVIQTl0R3lRcTVoRkdJakZDSlRPZ0RSOWhs?=
 =?utf-8?B?TlVrVk1qblI4ZFQ4T3o2OU1wZURjc1pxbENwMjJtVExlZGZidmxVNnhoWE1V?=
 =?utf-8?B?WG5lbGM1UitKdmwxdks3ZEJJQUlnTHhzTVB4emNvWkJ2STBINUZtbU13V2Fv?=
 =?utf-8?B?dGIrcXJzc3U5YlhRYzBtVE5CT3dIWXVnQkhIcGx1UUYwMlJoVTFKaytkWS8w?=
 =?utf-8?B?cW9qQnRqbUdkOEh3M01QL1lKVHlHTHc3SGI4Tlp3d05mMWJzTUdUZmFyc1RH?=
 =?utf-8?B?TGRra3B1VVRBOElENU0wWUNFVXdXRVMxdzhuamhhUFRQemhRa3lWU1VKU3Mw?=
 =?utf-8?B?UlFMTlpOZjA5V1RuRmo1T2t1SFVQZzZRaENrUkRmZ2Q2NDNGSGhQL0dXNFFV?=
 =?utf-8?B?dGV4N0lFV3lvcTZNd3RvL1hDMU9TS3VlYnJ4ZzBZYTZaZE5FNFVGUDhRNWQ5?=
 =?utf-8?B?TW1tVytPQzcxVlVSdm4yTWZuL2c5eFhxQlpJQmxYZkk0UUZrNnBLV3N1U1RE?=
 =?utf-8?B?RkpGUGc1Lzl0dW9tWER6RlFLVG5IUTNlc21ZOXdxWTlicU5INW4xRVRpN1ZS?=
 =?utf-8?B?M3kvaGRKUUNvNUdrM2t0VG5IMitVSDhhT1NIR2YrWFZsK0o4MVMxWmNrUWhZ?=
 =?utf-8?B?Q2dHcUdUQVRhRHdIbnEwTmdmRGZKUHhOc25paUgwT1NpV0tOTXdZRWVxbVRu?=
 =?utf-8?B?cW4yVU1ZWWsrVE03Q3p1Rk16MllBRnQ4SEJmMWFxcHJISWxQQTJ2emdvazRl?=
 =?utf-8?B?d2NUbHJQRStjeTQzMHJyTUthM1ZGQ25HMkZpcUtEUVpZUDhVYWNqbEZUSm00?=
 =?utf-8?B?cU00elcyRmxYT0lZNUlIQmVGbVZrNzEvK3lERklKTlJwNXhhU0VUb2RiWVAv?=
 =?utf-8?B?NjhFYS92a1hmTmdZNUk5QWo4NWo3ZmF5MGRBTDhmdlJHZmt3SHdYV044eTZk?=
 =?utf-8?B?YytNSHJ1M1I3bXFweFkvWm1qdmJQRm9pRjBpWGVNZXBXZmlpY1dmczJPTXhr?=
 =?utf-8?B?QXBpdzBQTUFtdmJhWnFWTFNqZUNwU2VwN2RWUmZyVHBZZHVueWNqRFhDOEV5?=
 =?utf-8?B?bjZGVkhVaDkvaTJEaUVHVTVCOE9KejJ3Tk5qNEptSzB6dXpiemI3OHM1U1FZ?=
 =?utf-8?B?cUlDc0NHMFdmNGR4alJldnRqTSs3clErYS9iU3FCYWg4MTJJUFNlZmVXUFM2?=
 =?utf-8?B?RlR2c2xha2tqbnFJZ25CZGVzaE50TTE0cjh2cnNOakpHYnBRbDc2ZWRBUU1u?=
 =?utf-8?B?U1NCK3VKY000L2paL1VGQWEwblJybGZNbXFndWdiTi85a1FKMjJvUHBIbmhJ?=
 =?utf-8?B?bnlubkI1VVlqc25XZzN3cHhSNTc3a3EyeUlsa1R2cy85YlE5UDFwWm5pWEcz?=
 =?utf-8?B?Q21MaEZCRDBsU2dZVE9ueTFFdnp6YTlraXNONitKQUt1SEVhN1F1dnNvaTdF?=
 =?utf-8?B?ekp5RndiNU5GYjc1QVE2MzcrcUtMSDZVaW9LTE1OMDJVSTJjSUpZdkY0S3Yx?=
 =?utf-8?B?d1c2eXBSTDh4WkVBRWlpZmJjazBPSURnUDBTNlVKQmxrd0ExRml0UHZ0SWsv?=
 =?utf-8?B?bHg0czh4OUF4TTJwSlV6Lzg4MEw2SUsvTlAwSzJFbmQ0T2p2ZEwzK0RQMUYy?=
 =?utf-8?B?YytoQU5ydlUwZlk5RlZZQkdlcVVobDRwYzc3NEM1dnZFalJqUWR2c2ZiOEVQ?=
 =?utf-8?B?VG51N2Z1QWpxeXZTUHlsNUE2MFRnblR1M3JFaU9JQ3hBZU5uQW0rL3RZYXlT?=
 =?utf-8?B?NCsvMnRjQmNBNENOQVJFTFpNT21FUlIyT1ZzOTl6OEJod3V3dW5xUVdwYk1s?=
 =?utf-8?B?UG1oUXFidkpzT2JlOTU5WG1OcjUwLzVqSWxiMUlKbzlJM3pSM0hvUXdQbzFF?=
 =?utf-8?B?WjU3Sk8zQk4rVFFzRVhhblJnQ0NkcEdBa2ZQZUVQc3drbTl0UEg3L2xRNllX?=
 =?utf-8?B?Z1FuK0hvdVZINk9iV1VCVjZOUVdtNWR1SjUrVzVvSDY0NHlKblI1cU1sblNF?=
 =?utf-8?B?eHRLUExZR2tqaE1wZEJvM245aEdlSzVhdjlaZXBEckNlWnZsNlBLOWFWNFdr?=
 =?utf-8?B?clVuRExnNGxLd1FCSGhjeW8ySEFiTDQrM0kwendmeXhtS2t5OVRlTTJHTnZz?=
 =?utf-8?Q?HnS7Fcq5Ydhdq6y8ENPkuzSITLuBA7dnjVn/7AkDGI5b?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83D4E2E7504C53489C26B44F2344D66F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2be1ed0-7f76-464d-eb0c-08d99f00d96f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 19:33:44.4909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e3jS04th/2IGLTyeCP4tIs8t4DceoTXoJ8C03YqsyS3CIe0OlFUFFh13VPRhjfSvfqDLSnM2AoEXX62/wsEVNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3351
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
IFJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbnZpZGlhLmNvbT4NCg0KRml4ZWQtdXAgdGhl
IGNvbW1pdCBtZXNzYWdlIGFuZCBhcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUNCg==
