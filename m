Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E455E3E5503
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhHJIW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:22:28 -0400
Received: from mail-bn8nam12on2079.outbound.protection.outlook.com ([40.107.237.79]:5440
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229967AbhHJIW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 04:22:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCpyPEKlAdAXJa4mapFDABMHul0SMluHKhj4pqe2xW0zBp9GR5ozrjPno2sQb5/LfKVuORQr78ZWe/1ksTdHWOb0BXsnUfVmO8+V4dCxNuIpTXX+HV2NvQjdF5XzV0hw6pdXoCDH05mpNw+78BJfPx9aOgaDopuYfua23jdW159ewQbtNZKnBqpy8LBZVxvp3ulP4dYGLsHlZiZpwdbh7b5lGUI+kXaPpyunr6p7sM0hjad05sgLzhVOJWFLBcezmpS+gDxAPKglMiGcoLPxnyaqShyKfgnG4rTRJ/BmknjDGt2vuX9pLNxrk0rSQMIH2BycF7bz6xLHRtfYGwDxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARdKXe0qI3nPb5NNvyPWl0S1pHAOXwrU0kebFTW2ZGU=;
 b=QtE2cxIbSyrRpNSChYKt2FFCLH3zOax8V0m7kw+Wh482DPilfWBuCFJ+SB0hM6KzRtyNbBWiV5WqwajkDyFrbdkKA0FHaid8IRjfyAXP549k6MEmW662Yi0aW3qwlrkzhmr4+MbmdOFgY6PnqrvMjMe9VgVWXwuzG3Rfiyb44yk08xtmkp8b7Uvcs5vcT6WhzqRjGgP/D/OWzknsSbGCdu2ZTyNG5AQQdq5uY0brviXIGcHuhvFsC8hLZsJpAxskTJkGNpiN3wUxTrUVWaIcOllf+CYBjs79NXcjpsRVumjbMSspofcqCQd7gSXdyudz+Rh0NCyW2Mz3nhSY0Yi9Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARdKXe0qI3nPb5NNvyPWl0S1pHAOXwrU0kebFTW2ZGU=;
 b=NuCYmUVLB3vIxu0ateI5O9yz4mU7ePkO4AHV8L3OoLJHP2K1GRWiCGKMnSMXGS/uPyHN9WrHwk7RcSDjKuC1zZxsrZ3akXtx/kHX782FCD0uEz/MX314QapxdA80yru8fV9tWwI1XKTUpM7lAj98m3zsiyz1ipsR9KURdHqEK1Q2fcDtszoIeJerMrMfCc7PGdtTZECud8ECM5wBhpX/o9OJPe48oKINZ/PMfHnbzLOaxQLrFc2w/Yv2j9+bO585cmwTGG5MgNmmhA6GkmBtcJq0fOHmWFcahHH2L785rjtfNlzJJMQUA+KbDdJnl1KuSBUPVYC/U2CI39DBjcOHOg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2903.namprd12.prod.outlook.com (2603:10b6:a03:139::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 08:22:04 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74%5]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 08:22:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "caihuoqing@baidu.com" <caihuoqing@baidu.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Make use of mlx5_core_warn()
Thread-Topic: [PATCH v2] net/mlx5e: Make use of mlx5_core_warn()
Thread-Index: AQHXjRjVMMy1IuWST0e7zJunGwt/mqtrowOAgACtFwCAABdMgA==
Date:   Tue, 10 Aug 2021 08:22:03 +0000
Message-ID: <d1456c73eecbe4ccb0353a275d1a48b334389bb3.camel@nvidia.com>
References: <20210809121931.2519-1-caihuoqing@baidu.com>
         <7b7dba6e8d62e39343fd6e4dcbd0503aadfb9e40.camel@nvidia.com>
         <YRIjoCbxAo+3SemG@unreal>
In-Reply-To: <YRIjoCbxAo+3SemG@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3 (3.40.3-1.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f53803a4-d4a9-4fd2-75c1-08d95bd7ef1d
x-ms-traffictypediagnostic: BYAPR12MB2903:
x-microsoft-antispam-prvs: <BYAPR12MB2903416A6F52626A14B2D33BB3F79@BYAPR12MB2903.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N00xb2Lkq1PNQHwPkyllGY+rmk+MRjXlBUkEES4bmiaiMztscgAiCw7+/5KFcG4qCqkrJOfQgl80hqpSrWCc8DBloSFtTDrbpgYSgLKx7WKuwNPc06GNe3lOtzjSvDLcYjdykFKsrdcKDUDQqb02R+Z67DZIeDj9EPtt/+C/GQMn9u6QVtvPsdyfTEL3+LVy0bbEJNKbKawgJVfv04eqBQYYnwLT86uAyRYVQ9Z50mKj8dsol/cckuxQMk8sWqhmMxlIUgfgEX1BL45xRmq0nQJnF9L0aFZjXs0wUzNCpHDHlwP7Z2iFCxDKSFeGFuYZXRD2P+8DNl9TPEzFovE7cAqH/ZM5WPWlDejacKXFmY8eKuO2WKfF6AulZUJo8HXHwIQurSMLoLDPP+tv/zMwiXtlEegveyljrpqXBFiWHWcsP9i7C6GmNZft/AtPMh04nhbvbWSiJglsaNhfx6172Ov0rih1rCRW0hqOM9dIz9q8b2Rpv0z0Orvg0gN+s9Puh0/FQls+qgvjQZ7xV/Lb2pVSXPrfOFXyvLyTrg2uJ/Z3kG+MLLU7N5eyli2XHz8/KPqJKCZjk+brXjptOQQ7LPE3DXLBqGOde5ckjWokfItSXKB2mfACLBQC/rGt7+m5A/53P5lHJyR6gn8NcNQH+ST7yHEz48xt/RYcCkwdff/BCf19YhvvC1H3Nt0uIvxucLnJmH9ICU8OFsKi6MJMUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(71200400001)(4326008)(316002)(76116006)(83380400001)(36756003)(8936002)(64756008)(6486002)(66476007)(66556008)(2616005)(6506007)(6916009)(66946007)(66446008)(38100700002)(86362001)(122000001)(54906003)(5660300002)(6512007)(2906002)(8676002)(478600001)(4744005)(38070700005)(186003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dndEMUtIQmVzWXhrS1V4MTVPczkySWtrNHptVHRPekRnSGhvdXJtemVZeUpM?=
 =?utf-8?B?QWpCVlkyc2htcjMzNkhRZkhBNzF1YnV3aU5aY2lZQjZLYVFvVWdVTTR3NTN3?=
 =?utf-8?B?Q3h6MmV1M1lvVlNyRlo5RVhaM1I0eGhCZk5mT25pdDZEeGxrTGRKTTZwSTh4?=
 =?utf-8?B?cGJOZ1RyVkg2cm1qeHZTMU9hUkxCOCtqV3dHaFJUQm5IL2llVlBFWjBwS2ZS?=
 =?utf-8?B?cFFVdjZFeGZYSEJRcWNFMWYzYVBiSzdSYkJ3S096dGdlYkNXeHpWL2F3WlZs?=
 =?utf-8?B?bnhFNVFldEtnNEt5UXlLMHpTTEF5UlY0Q1E1eDNXTWJKdGJxWDByMmMvUWZR?=
 =?utf-8?B?aEExMUtRd3hRYTlsSkQ0T1I5SGp2UlIwWWlwOGM1TjlzanBNczlsTHpYVWVZ?=
 =?utf-8?B?WnNidE1qR3oxaDJVNzdQamMxcmhSMGM5TWl4NnhXN01na3RUY0pUOXZtbFFq?=
 =?utf-8?B?VEFkbWIxbjNJRy93NmpyTTR4bW9GS040em83TkQ1akpBTlYwV1ZGSVA2S0Rm?=
 =?utf-8?B?SytlRkpid2MzbTZndUdYUzlwbjhlWnVrZkUrdWxCZTNBbXA1K3VvT0RUSHBl?=
 =?utf-8?B?akNzcmVWSE1DL2lmdUlsVWhQaXpGVmVKYW5DMzVYTzNsc0c1SlNrZC9MVjJF?=
 =?utf-8?B?RXZheW81MURxSklyMUxFQmQxUHRneU9DbDZkM0NNV0o2UFNlUERlVXZXQ3BI?=
 =?utf-8?B?YUdVTkwxd2VWdURUVHNvQ2RhSnUxaUs3MlBQSkYxUk15OVo1OVlBLzczZ2di?=
 =?utf-8?B?YjBMR1d2SVhMLzdMMkZlaFZwdGhLNjQ0OFo4Q1YwcVdkMU8yTXZ4VjlHOE9C?=
 =?utf-8?B?dUhmcEZGQjdWN1VoaXp2enRCT0VNVjY2OXBsRFA3aVZXekV2ejQ1cjNCUmlm?=
 =?utf-8?B?VWVuajV1NllVSmtQdS8vMnhOZjhhNVllcnNFRmVtNmFhNEFFdDlKVWlhUFV1?=
 =?utf-8?B?TFRqUDcvS2x0VEMrS0dMa21PT0doVWtwZGV5MkxyUFhhbDBydUZDN0cyc1Jo?=
 =?utf-8?B?ZVNsU0VqUmZMS1ZSUEpXeFQ0WVlaR3BVaTlzVDhONnY3dTh6M2FLUE45c2F4?=
 =?utf-8?B?dyszeGQvQnZMcmRhOTVVQ01PNzc0a3lzQW1VOEJCNWQ1L200bGpsa1dKRFJN?=
 =?utf-8?B?UlV5T2kyRkM0WGlkelZQNFozc29WRy9pRUpjelVUalk5U0hLcHlnQTViSGp5?=
 =?utf-8?B?RS9yZHVoK0VlS3BObjVvUEdiN1o1cUlvR20vL2FUbnk2YzdCT3B0VDRGb3BQ?=
 =?utf-8?B?RkgyaVBrVUFtN2gydWZJNGJoOGdib2RHRXZRdFVseEVPbmtEckVmMlVYbFY5?=
 =?utf-8?B?NTNNbkVHc3JhUDVNREEyS0VYUFgxWGp5T080Zm5LbW9rMUc0bXZiTTJvSEo3?=
 =?utf-8?B?aVNVS1B0ZDk3VXBXVVdDOVVsTXJud3h5Rjk1Qk82NDZZRmxXTVlnSWExSkh0?=
 =?utf-8?B?SjJoYzFXS2xONG55MkZPYytwNXdWa0hWKzFReUFBWmFKRVFtbkw3VEZYcTRV?=
 =?utf-8?B?OU42YWIxN0hkam01RDk0L2pKRWJ2UDRMZ1cwb3R5UmlCTWFhUmVLVVVJUU45?=
 =?utf-8?B?TnNhSng5TTl3TEpOcWhhSThRbTdJNkd0ZnpTbkdocmRQalJPaVB0TTZHcG1G?=
 =?utf-8?B?bytabzdjU002TVlKU2VZNnU0RlcvRENLQjJoYjBITmNPTzNKeFhWYjUyaFZH?=
 =?utf-8?B?cVcweldudFkvOHYyUkpSRUJhM1IyTS8yc214YUZLRFh0TW5uVnBBMkRwSWVH?=
 =?utf-8?B?WW15SDdobWcrVnVLLzd0VU1uVnVRd1ZxWmpDcFdQeWlIRHhpblhxQ2FzZmlM?=
 =?utf-8?B?WG1EdzJrZFdiWnVYc0hjUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF33F5AF15E4814CAACA97DA0F06D63E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53803a4-d4a9-4fd2-75c1-08d95bd7ef1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 08:22:03.6322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uiY2X1MFlXyr4VN5XzoBOC44aEdJ0ba5wFZtcs1lVamKDKoiK0jEbeoxWwKvSyc5nDHM95Esd+mFMbri5dBDhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2903
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA4LTEwIGF0IDA5OjU4ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIE1vbiwgQXVnIDA5LCAyMDIxIGF0IDA4OjM5OjEwUE0gKzAwMDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMS0wOC0wOSBhdCAyMDoxOSArMDgwMCwgQ2FpIEh1
b3Fpbmcgd3JvdGU6DQo+ID4gPiB0byByZXBsYWNlIHByaW50ayhLRVJOX1dBUk5JTkcgLi4uKSB3
aXRoIG1seDVfY29yZV93YXJuKCkga2luZGx5DQo+ID4gPiBpZiB3ZSB1c2UgbWx4NV9jb3JlX3dh
cm4oKSwgdGhlIHByZWZpeCAibWx4NToiIG5vdCBuZWVkZWQNCj4gPiANCj4gPiBpbiBtbHg1ZSBp
dCBpcyBuZXRkZXYgc3RhY2sgc28gbmV0ZGV2X3dhcm4ocHJpdi0+bmV0ZGV2LCAiZm9vIGJhciIp
Ow0KPiANCj4gU2FlZWQsDQo+IA0KPiBUaGF0IGZpbGUgaXMgZnVsbCBvZiBtbHg1X2NvcmVfKiBw
cmludHMsIGV2ZW4gaW4gdGhlIHNhbWUgZnVuY3Rpb24NCj4gd2hlcmUNCj4gQ2FpIGlzIGNoYW5n
aW5nLCB5b3Ugd2lsbCBmaW5kIG1seDVfY29yZV93YXJuKCkuDQo+IA0KDQokIGdpdCBncmVwIC1F
ICJtbHg1X2NvcmVfKHdhcm58aW5mb3xlcnIpIiANCmRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl90Yy5jICB8IHdjIC1sDQo0DQoNCiQgZ2l0IGdyZXAgLUUgIm5ldGRl
dl8od2FybnxpbmZvfGVycikiIA0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX3RjLmMgIHwgd2MgLWwNCjI0DQoNCjQgdnMgMjQsIGEgYmlnIHdpbiBmb3IgbmV0ZGV2
IDstKQ0KDQo0IGlzIG5vdCBmdWxsLiBNYW55IG9mIG1seDUgZmlsZXMgaGFzIHNvbWUgbGVmdG92
ZXJzIGhpc3RvcmljYWwgY29kZSwNCmRvZXNuJ3QgbWVhbiB3ZSBuZWVkIHRvIGtlZXAgdGhlIG9s
ZCBoYWJpdHMgLi4gDQoNCg==
