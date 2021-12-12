Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7909471960
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 10:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhLLJE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 04:04:27 -0500
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com ([104.47.57.175]:6240
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhLLJE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 04:04:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLmUWVhGrQeZya5WjbGm+CZBYjM03RtE//Q7oDeXxARb3xkrcTP8QT78vJup4kNTU3BMOm/eKqCLaWFt5UCka98aN8+XPzpqUNE8gDwr073HFSHDV7585dlA6YMJvDMxhx21D7QsTD4MUY5fzQvWR2zsjgjrzEGNisLNrJomwsb3FHF8VadiOmqTIqgiIzpMDAyBFePd1goe+Y/iUUiOF9xBuJnLjKp+Lc5nz39RcTmSI2Nhu40oWDRvggz8vNw5LWGnJpa44L2P1n0BV0PUvhQx+LgitzDM/uNpJbSIAxR620BZUZvammGUJSrVyKamcL1Wl4MyOkGQsJL5bygpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vy+0QiXe0wtNjWgLBDuojEczmWUhxIO3ITJttYRuzqU=;
 b=m9lFoUZsuzvVNGYzMAjT7Zm0wUTtG+NOJNrNM/ZQGnb3NxaQxIBmAFZhwjZULmjqB0UWcFhG6Fs7p6x/BdZ2pjl6Was/fPwyWtPzE1v0ytHlBYd9MM+4rV4k+okp83sT6GuLhFKrl94RMm1s+xGPHQ/Hy/HcBCWUeRhWIqyuvhnlDTchmKiK6QwPZOMboIqJN/wmaLyVgDB/ylEUXoxcPtj5g9PUvMNgb3t5wp13s66QkQ0UG2SmFQLOnlAUIybL1uZrb8t8GG7DMB70p9v6n+mqnv7sjs539GQrvWBds1vGfJmhIwO4OV+/WSwcgrLF0ZkkITg+pwWr3V/xLtyaHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vy+0QiXe0wtNjWgLBDuojEczmWUhxIO3ITJttYRuzqU=;
 b=IjHlL9rEsYsNbXv2P+NmWcwIr99zED1nHM1CaUjn3VBIunlG2wuLm2QuNHlnCwzLYYKrg4lMFVprELTLffAqF1j7S9Iy1AUEmkPet0DqemsJTFidnOQRD0imATs1yTnObUf7oYgbshwIZlveGRl/sHmN3PceVeCkD2E38p5FQ1w=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM5PR13MB1865.namprd13.prod.outlook.com (2603:10b6:3:135::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Sun, 12 Dec
 2021 09:04:25 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4801.010; Sun, 12 Dec 2021
 09:04:25 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v6 net-next 12/12] selftests: tc-testing: add action
 offload selftest for action and filter
Thread-Topic: [PATCH v6 net-next 12/12] selftests: tc-testing: add action
 offload selftest for action and filter
Thread-Index: AQHX7N8y1GUY5P4xWEOAuVuJCfz/0qwtuM0AgADbTgA=
Date:   Sun, 12 Dec 2021 09:04:25 +0000
Message-ID: <DM5PR1301MB2172F34448BBD683411C8848E7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-13-simon.horman@corigine.com>
 <747730ac-8421-1f10-cac6-5c4518bb204b@mojatatu.com>
In-Reply-To: <747730ac-8421-1f10-cac6-5c4518bb204b@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4105d528-04c6-43b0-7909-08d9bd4e6569
x-ms-traffictypediagnostic: DM5PR13MB1865:EE_
x-microsoft-antispam-prvs: <DM5PR13MB1865FE86630386F02723A2D6E7739@DM5PR13MB1865.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/r3ZIVvUOSIQ5xYChxpFY/xgu6X2CJOgJ9vMUuVSdm6n6rHcCbjwS24ew+p2oW+O4U7sj5NSq89uNlXB6MYA85FD56Olcj/ml1QuyFY1pThRKPbCOuP2E04CjLZrPzn0VUbLg3YmzFGF/7yUm3o0z4Nhbr24O3OG9A8C/oP1XBfBQFrG4H7g6sYP/Z4SOxBV+m53dGa8HcHJfx9iS95xvfYNVDuCwW2hRjIGJ3QcPmgdmP8J6AO2SNPnjIKNDMNE1gqMiNaYVUioJO+TnVeVdlrbtbPKbvfcdHRvDS1LmGLHNpWhFbFuJv5x9/4MT16wWB4ea0if2KhMb2DFSq99NJ/UXhUx0QgbT40HMBdlkZr4oymn+6cBlexQvWRnqtzaz12UZMogjYl5vN3QMHX3G2CRQenig+ViqgZ7Bf88XFVqJiqn6vKJUlLa06RhAY08OnU6Y8Ntgm5X2W6Owo/4HxZrDQ3Kp0ITRngYj6jfXtyHTYaBYl+cyljFbJOkPma7Yba5qS6GCIfDXp9wxyDIgtpkEX2Wx0aCIfM0sAWsRA7Pgd7jkJVwkpx35dTRB0cqKsgQZt81DPrncF2mKoh3ignYXMWxDvhDylPCuJy/mNN5g2PYi9ipGkvsdloLtYENSaEO67pFf31fpQziFtGZKDXhN2Y+hArrS0aTjUhkwplpSoxANSkJLy/hM3I+F5FydjLYKPZUvPBP1yCMXCb7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(39830400003)(396003)(376002)(346002)(4326008)(38100700002)(66476007)(64756008)(66556008)(66446008)(86362001)(8936002)(26005)(52536014)(122000001)(8676002)(107886003)(316002)(508600001)(71200400001)(110136005)(66946007)(186003)(76116006)(54906003)(38070700005)(33656002)(6506007)(2906002)(7696005)(55016003)(44832011)(5660300002)(4744005)(83380400001)(9686003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm9LVE1sNzlKM1pVTmE2UGJMQjNXcTROMGtMVW1aaFgxdGFFWlNTWUxaY1Rm?=
 =?utf-8?B?b0lHYjgvYTB6c1U3V2l1NmNscFZXNDBVcEZDdFR1WUZxSzEyWXZKUjRDWjRl?=
 =?utf-8?B?N3B6QlM0TDNaQzRwL0NMR1hQRHE2UHFld0tSVy9hdmo4L2RFejFvT01yVC9z?=
 =?utf-8?B?T0ZNSjZITUs5VEprdWpTRzN2RlFZU3UrWTZvb3hQODJBdTBia0hnanpXVk1j?=
 =?utf-8?B?dm4ybFJjNXRqWDhBZm5oeUdMcTZiWUpLZTdlYzltNEVvU0YrcTREdHg3Q0Vs?=
 =?utf-8?B?QTFXZEtDYkR4YnJnWVNUem5sYWFhWkV5YkZQMWxyY2ttZm01RjNJUklDOGNV?=
 =?utf-8?B?NFZ3Q0VOUWF1aTdhcWZVYVlObE5EU3RIMnBMRUNSaFpJUndjejVzVldpWm1u?=
 =?utf-8?B?bW5Hbmp0Z1JpY1F2MW11VUwzbitjTlBFUnNnOVFML3J2RFhaamZEK3BIMHZJ?=
 =?utf-8?B?YlNtZHVmdHRnWDhtTm1zMXFzV25vbEVwRmU4a1hwU2NuYkNNNnkvQkl0Ny9W?=
 =?utf-8?B?Zm5TRFJDUUd2QkxFenhPS1RBQWQ3MTV6Uk5wdXQzd0hwNDdjMnh2S1dOTm5J?=
 =?utf-8?B?ODgyRVFVQWs3QU1EWWpLYnhLdE5wMENIUlY3RFlHbWxDd3ZiWHJSOERHU2tI?=
 =?utf-8?B?N0VZVDVqcXlTMGJmdUNKb3QzMUkvdHZReWtoQS9PK1ovQ3RCcERCM2JqUEVv?=
 =?utf-8?B?S0R6Szd5eVFudXpVeCsvV3k0YlV3R0tSWFlJK3o0Y1lwTHBPVXhvTEtLSWJq?=
 =?utf-8?B?SHBEUUI4dXJXS0RpcEJlYXI2Q1p3VEl0enhKR3U3QkpBY2h2OWQ3REprRUdW?=
 =?utf-8?B?WU9GTllnMnA0VHoydGRtSVVWRmVGbjUySG1FYkVublNoRTRZbTJ1UW9kZktL?=
 =?utf-8?B?QmRBM3dUU1lhbTRBSFlCVDZPV1R6eFdGeUwzQWwxQzFYaUVzYnEwd3pEcFRZ?=
 =?utf-8?B?RFhuOGMwSHM3V3o1MVRJVHlUdkU5RUliWGhUNXZob2N3TVlRMHk3NldXM3Fk?=
 =?utf-8?B?YTJSUnZjcjdPWngrcnlkb1pRSGlXYmxPdlBGZXRyTzI1TndSbDdscE01MUJm?=
 =?utf-8?B?MWlZY1FZU0hxTlg3cnplTkVDYVRlbVlLQzAvQU4xamxyNHJqWkFpNzY1SUVE?=
 =?utf-8?B?UDhzSWlvdnVJN2N6NFdpN2Y0dlhQWUh5OWR0UEQyR2JFOGpNSkVMQkFQSHlz?=
 =?utf-8?B?MGZRUUNGL21DdzB1aXFSMGtscHNLVm1rbHRjSlhyVmF1WlMvckxPSWNtalFP?=
 =?utf-8?B?eUtNc0lVRkQ3WEtiMFhOK0w4cEVFV3RjdERMaDRKMnVQVWpuRkQwT2R1ZW9I?=
 =?utf-8?B?MjB1eWxqNnRuenNLWkJtUEU1TkFGNHJnVUQrS2RtOW5EY0F4WlFGN2VqcUwr?=
 =?utf-8?B?ZytRRkZYc1AybkNnWkpTNTczdmpBbnMwQ2RxU1hFMnVlMDBVbTJHVWpqL2V2?=
 =?utf-8?B?eGc5UVlSamRmN2VBMnNJall1a01iM1N5anlZZXdWRHVOZWZreWJNQWhvb2lQ?=
 =?utf-8?B?cDNHNkNEeEcvZzdML09HL2ZrdkFwN0VnMFJHd29sK0Q4N2dPUkc4MFkxN2xH?=
 =?utf-8?B?YU9lblNtWEw2M3JTREgvSGpCQjhPOHFMMDVMMWdGMGNxbE1VYUIveWV1MXF0?=
 =?utf-8?B?ZlZJUDFGcHVsVkwyMnNoVmVDMU5kck4wUFRFeGFCWWRYQ3BGSEZOZi8zS2Zk?=
 =?utf-8?B?SnV5UHFDMzl6eVozS3ZsSGJwVFBjbFVpeDZoZHNnUWE5a1JVdk9ieGdhRm13?=
 =?utf-8?B?d3ZKWTBJb2x3VmdRak1FVXVpaEZDczhObnQxNDJDV2d6UHBVd3ZGaEdOZE1t?=
 =?utf-8?B?ZmlvVkQrRzFzSnlwNkRjbDVjNzl5QjBCSXFEQUFBMWRXcWtBV3dUM29Bbmtw?=
 =?utf-8?B?dEFKUEhMQnBjL0k3QklPalVwUVBYWDlGdllRYU1hY3RSdlZJNDhhRGJKZjJY?=
 =?utf-8?B?UG5UZ2NJVG4wdERMMFhmQnpqTXdvNGdpODZzcEY2TGJxZk1oTEIvZ2dzUE9H?=
 =?utf-8?B?bnRod3BBdUtZcFNRWkZBUDZLUytoenJBOWVwNUpDV2FscHQzS2RMOC9kNkd1?=
 =?utf-8?B?Ky9sVFA0NzN5WEtXcEg2eW5JZHF5eS9EV2FRSUxjenVKZ2tBb1paTVNDcTdO?=
 =?utf-8?B?anBySEErYWVLQVAvWnhuNW9pNWVab0NLUmhlQ1RxNDJ0cnhsSk0vdWRDSFVN?=
 =?utf-8?B?aUpoSGdqVEsvVFdJeldNSlh4c3FaQ09kaStFSVZaMDBFRUo4d1RrL2lrT1NV?=
 =?utf-8?B?dHdrK1g4ZytQcW9FL1pSRlpRN0pRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4105d528-04c6-43b0-7909-08d9bd4e6569
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2021 09:04:25.1428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K1Rdy9qnu8PywhEVCS1pE+Jt0WKWJLljhpCvUVwu0H5IIyFA3aRweQ2I0OQTy5cUC62JRHtNGlERwFJ6Qx3qQ26YhQNrooJ8iRLs4bS8yH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1865
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRGVjZW1iZXIgMTIsIDIwMjEgMzo1NyBBTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTEyLTA5IDA0OjI4LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+PiBGcm9tOiBCYW93ZW4g
Wmhlbmc8YmFvd2VuLnpoZW5nQGNvcmlnaW5lLmNvbT4NCj4+DQo+PiBBZGQgc2VsZnRlc3QgY2Fz
ZXMgaW4gYWN0aW9uIHBvbGljZSB3aXRoIHNraXBfaHcuDQo+PiBBZGQgc2VsZnRlc3QgY2FzZSB0
byB2YWxpZGF0ZSBmbGFncyBvZiBmaWx0ZXIgYW5kIGFjdGlvbi4NCj4+IFRoZXNlIHRlc3RzIGRl
cGVuZCBvbiBjb3JyZXNwb25kaW5nIGlwcm91dGUyIGNvbW1hbmQgc3VwcG9ydC4NCj4+DQo+PiBT
aWduZWQtb2ZmLWJ5OiBCYW93ZW4gWmhlbmc8YmFvd2VuLnpoZW5nQGNvcmlnaW5lLmNvbT4NCj4+
IFNpZ25lZC1vZmYtYnk6IFNpbW9uIEhvcm1hbjxzaW1vbi5ob3JtYW5AY29yaWdpbmUuY29tPg0K
Pg0KPlRoYW5rcyBmb3IgZG9pbmcgdGhpcy4gSWYgeW91IGhhdmUgY3ljbGVzIGFkZCBvbmUgb3Ig
dHdvIHRlc3RzIHRoYXQgZmFpbA0KPihleGFtcGxlIG9mZmxvYWQgYWN0aW9uIHRoZW4gdHJ5IHRv
IGJpbmQgd2l0aCBtYXRjaCB0aGF0IGRvZXNudCBvZmZsb2FkLCBldGMpLg0KPg0KVGhhbmtzLCB3
ZSB3aWxsIGNvbnNpZGVyIHRvIGFkZCBtb3JlIHRlc3RzIGZvciBvZmZsb2FkaW5nIGZhaWwgY2Fz
ZXMuDQo+DQo+QWNrZWQtYnk6IEphbWFsIEhhZGkgU2FsaW0gPGpoc0Btb2phdGF0dS5jb20+DQo+
DQo+DQo+Y2hlZXJzLA0KPmphbWFsDQo=
