Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8E6453B2A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhKPUrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:47:53 -0500
Received: from mail-bn1nam07on2062.outbound.protection.outlook.com ([40.107.212.62]:51589
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229527AbhKPUrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:47:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noNKS2T9Xcs5QiDEkEvO0Z1Tqk6bO0e8kyAMcHISchV8lluCvmQlTKjt310IOpfY3En48Euhi49A8uhd/B3nU9P6F5jr72pFykBnViIBOzcfVGyzEIUOTviEC0iQueevTGcWZlBM/pqwGTCELxPySb5EcmFaR2ScHDwL+hCEjivmzuMdV47XBsJMGSXix3/beao+KMJspqRldtYgh47YHQMwy0Azis6k67hjqyJDcsPOsOmIC1dsjymPohXnpg5qAEXlvL7u78fkZZeEK0HWrH6BawFnFic4GOGdh1yPIQbJUJy/vU7aO6gIEv1JP8BkC4MpkcRmRU33T9DPIl1dgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovmEP7H7FxGAc99ECMqAPKgDwB2Szakgx+aHxaolgFU=;
 b=c5fOA6/Q98oKw/JFaWYxKDp8HBlTqMO7j4SJ6nlFWnHb3QU8jdK4aPXi2qx9bqObpzNHMW8TiLDJvYYnri1ptVDR16q+vP3JlsJlwdolNqUzbnPMw/tMROoRQ4V7vsLwla36xO5zh8zlqvdnLFZOzmteWFbehTijN94bWXWmONCRqp0fmlLXtqxxB82YHHxKmsEpesXyOBKXzpRO29M3TEaNb0rVGYjEHg+ed29yp6TnivJB7FJ0GjrM7rYYGkG2QXEPApNqpnvm07cqnel+ixUjYesKNIHdTG24HCIhEXQlypN/lQS5FEadybSec76Mueut1Sh5D5r6RIglOE0JKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovmEP7H7FxGAc99ECMqAPKgDwB2Szakgx+aHxaolgFU=;
 b=Y/+mh8KiDhuTqFE595Y/9UBFW7Zq6bkgXyb0apSD8sjD2z0RuLMf599mBo1rdBIedLyqMn7jqqiUP33Gz9NhOeU0R33q6up3zcgILfwd71Fdl+5jilDpBQwJbfDtyvGXDUVIUEcLdZlTumNB3UOBG88JBPZ/imZEP7RQiH0qEpi6JUxP9/eybSTAbjzijjCAc41TVQZPVFiIH2n94hLIPWd7j7iUXN4YkOojelWkvabNM3hdJW2A4Zrh+AvAX1j+7XP5RGnvACtmUaWtLF9wEeu+zEpISYuAFdDTG6ha8ZcwGox8Dc0qQdaL0vhxZ9awMllmMgRw84bUTL1Yf19Kpg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3256.namprd12.prod.outlook.com (2603:10b6:a03:135::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 20:44:52 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4713.019; Tue, 16 Nov 2021
 20:44:52 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Fix some error handling paths in
 'mlx5e_tc_add_fdb_flow()'
Thread-Topic: [PATCH] net/mlx5: Fix some error handling paths in
 'mlx5e_tc_add_fdb_flow()'
Thread-Index: AQHX0zDkr3oAySRU9kyflxvz03hkk6wGrziA
Date:   Tue, 16 Nov 2021 20:44:52 +0000
Message-ID: <d1ebe491633b6a0e861fed0b6312e17f5fd284c5.camel@nvidia.com>
References: <3055988affc39dff4d2a5c00a8d18474b0d63e26.1636218396.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <3055988affc39dff4d2a5c00a8d18474b0d63e26.1636218396.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f3dc12e-b821-4a02-84d0-08d9a941f096
x-ms-traffictypediagnostic: BYAPR12MB3256:
x-microsoft-antispam-prvs: <BYAPR12MB325664FC60F5448BCC15D62DB3999@BYAPR12MB3256.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4SiOOUu+FZcQTs2yU2XNub/UaKqcQaZeUK3qMjNN5lDF0xCOgPyCqMyCb2+9Fr+cTGMZP2T9/EhnnrDUYfXEVvlM4ereZ64IvoVZGenjaSBFOI+gsYo+QxQhNMSlY25/2iiK26vuf8fJG9/w50+KI+82Ye0oE03i8pyMo1O0zXLcmKkimT0z4ITKphrIdItGaB2oJZQqoxqlm2EDk4mUL4VEqLCwEWb3sPhK5kAZng0Uha2nphfZSApQqULTg4ty3NKhwt97pR2GqSpUfJB8PRRyHA2e8vSx1ub2Q5l3nJIq/klXCVFeXOx4oV65XSY0I2GvNbcS7Lfj8qhHuNUu4+VvwWjqFfgkXkvBv7bGdsdraW16VPuZnMpWDEOi1e6F4suP3MR9KJu2+YBJyfRpe6UcVGWxPOvGq3LylUbx8wt/1xf0RUvSiWOCWwCgzc5bj4oe/11uIS67KYUW3bHe72AhPp9nluTOIjug0PnNNyYI2JmJKfr1c1PVNK2pmSWZuZuvOvd5tSjRFzpf+Hs/Ij5BMYJnee4VY/rZQDYXWtPFJg1EUlnXRTLtgFevvk94y3iMbDhXLQ181YdsLO0k4bpCUi+yyZ1Lg3OFHjfA/OYUbSDSRjdSrowSl/uoltP/XRpjPiBW6O0HDMT+1HapuB82WVGIwgI8LPxM75yf6sFYRjA93i48CvbD6smBIwA7jZno6BO1U7pPKHwTmIK3nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(8936002)(8676002)(26005)(4326008)(4744005)(186003)(71200400001)(38070700005)(36756003)(122000001)(38100700002)(6512007)(5660300002)(2616005)(6486002)(86362001)(508600001)(66556008)(76116006)(6506007)(66476007)(66946007)(110136005)(66446008)(64756008)(2906002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXlhOU9LczNEekU2OUlwdEhMbi9Xb0JYS0Q3WlRBK1VrRGFNNk1SL2ZkTmJL?=
 =?utf-8?B?WnJtdXNIUzk1aGYvdUREWWgwTWpkbU9GN1QxcWxnQjF5eTMzM0t3M3VyQmlY?=
 =?utf-8?B?U3J1VjFUSjFuaVR2MnFJMDZadXlHZWlDWjN0TmJDWm1DOVNGa3hSWk85S1M5?=
 =?utf-8?B?WUU2aGltZENtOTBSeEsvK004SmJPbGN6dFdHeUhNWEJPVFRxZjh3MXUxTWRR?=
 =?utf-8?B?L2Q0aU1BbmU5ZHgyZ1gvTm5lSVYwa3U5aHBHc3d5TVBCYmZXTGozeXRtZnlk?=
 =?utf-8?B?OUdrT01qTVk5RVRsWWVxbUdHWjcxU0RNSHVubk5pcGtpRFB4SXgvc0pGVEx4?=
 =?utf-8?B?RkdhaWpBSENvS2NndnQwQVJmcWEyeGM4TEx6WnU2bEtyMUl5QytqU0dFL2pP?=
 =?utf-8?B?bHNWTXpuZ0I5dWZoRy9QcTluNHQ5U2NIWDhXRy8rU0JJY3pHL2RxczRoUWFR?=
 =?utf-8?B?VkN2MjJzNHprNGhtUW5WS3doM0t5ZlkxVHFRWlUwVmlBT0FWdXg5TFZHM0hF?=
 =?utf-8?B?K28wSTJCYzNCRXdRcGVqZFNvUmJZNWd5dXE5Smd1U2JURGpVdTR1SzhLbzNM?=
 =?utf-8?B?VHVVcWZXcUhrbHFwNFJ2Y1F2bmM3WWdsVHY5ZzFJbkZ4QnJEdTFTamFZVFlM?=
 =?utf-8?B?NzFJSTI0L1ZTanlaTGpnend6WDlBKzBvbUhyWXZBWG1wUG85NmR2aFE3eDdn?=
 =?utf-8?B?VDBseWZXdzVSUEE2ZTl5OUVBSENPU2FjS3c4QlNKK2sveDMybkhNZ0wwaWg1?=
 =?utf-8?B?Z2RZcnpKQytqMk45aHdWN0U5NEFJbFpGRENnTVlFT1ZPdmFNUm8ybmRXTXIv?=
 =?utf-8?B?TWNZNEd4SmJSdXVZaFo4ZjQrTFl3OTh2dEFiUHNSSFg0YTA1Rk5CeTZ1NGc2?=
 =?utf-8?B?ejhPdmZqN0NmalBNUGVkTmM0cHhjNTlMK0h3emQreStkUmp5MFJPZTZlVkQ3?=
 =?utf-8?B?RHhIWmx3WlVLOUd3ZDEwc0NsNHpjcHgwdTRQV3MxRXZSMkxPendnaDFvbGdK?=
 =?utf-8?B?djlKS2lVQTZCdzJLYmFDN1FCZGgvWk1GcHplbmhmc29XMklDRWFBNWRKWmRI?=
 =?utf-8?B?TVN1YWd2UStFL2p0aEVWRHljZGNsS21OT2ZBbVd2ZzJJUG8zUEZRMmF2d1I1?=
 =?utf-8?B?VzlwTS83bGJKelFCTGxUVS9DTExjcHA4TTczZGxvbyt3NDliY01La21sV0xG?=
 =?utf-8?B?U1B4WGwzaC9WSmJLRjBiUWJvUEMwb3ZRQzQ1SFRBZmtsRDJmeGVsMUhRQVhG?=
 =?utf-8?B?VGtKV3ZTUmU3b0Fuc2lRVG9KbGlKNGMyMFl4MndWekNmZnJIRy8yUUxEdFFY?=
 =?utf-8?B?cW9oeFdPRG9JUVE4eC9PNGxaWmNJVWdUUHFuQmxjSGc0Q1ZJWVRqbWZzdnA5?=
 =?utf-8?B?dEhCUnh5RjNQSHdsL2FFZEsxWGx4Z0xBVmhCZE9KYU0rck42Kysvem5OaXNJ?=
 =?utf-8?B?NHR0eFZWOW9ubkwrRTJBV2VTUDZmNEpYSFF1ZHNDaVJydEF4QnRVcDI5QlQw?=
 =?utf-8?B?dEZ4WG5jV0lXZG91RmM0MlhlQVNkTlU1TFc1Z3F4KzBDZzVIMUgzblJwK2Y4?=
 =?utf-8?B?cWI1ZEFFUVpuelZSUndsVHhoNWI2dmdreXR1TEtuMlhvWHN0U1pvd1kxcTd2?=
 =?utf-8?B?UTBEcElPL2FnTjBIeGM2WFhUT0c0cWVZTjM4ZjVIVnI3UjJtdnBFR0JBK1lm?=
 =?utf-8?B?RTIwOUNLSUNHY2hvcHU4aXhVTHhWS3BnSHk0K0Y2NDM3aFZMVnBpYmFiV3Vr?=
 =?utf-8?B?KzdFSFN6cnlVa3o3VE0rdXl0MitDQzUzMUY0WkZPN2JWKzkrUlJ5UlNkL1F3?=
 =?utf-8?B?RUJVaVJIUTFEc3dpS0tHV0JBR0IxS2pJQ3JYRlNzNzc0OXQ1dElBNWFYOHVQ?=
 =?utf-8?B?bmZmbURNRm9sZjN6ZnZ4WHhSNUQxZDVKNUxRLzlDcldzblhOUVRYL2tTNTR0?=
 =?utf-8?B?a2dYSG95ZjU4SWdWb0V6czFXTmM3Q3BlSzltMXhMdDd0c09ianRQQlZ3enNo?=
 =?utf-8?B?YTI0T3Q1MlVCL2FKYm1PcGZYd0JvNTFNTWRLV1VqUFlyQXJCSXczNlZkTklq?=
 =?utf-8?B?ODkzK3lMOEhCejJsQzRuMmhMb3JDdFdmbmR6c3NZQlg3TUI2VzN4SVYyci82?=
 =?utf-8?B?Yk9TWGxHOHBkbTNmMzA3WHg1SUREbmxZK2ltMnUrQVJWV1l6SC9OQUJYKzR6?=
 =?utf-8?Q?oiXaQDjZUuS0rmQeHEVP90gNU4OonH/avifk67v4RoXJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2532AC32558AB34BB45E514055D3C893@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3dc12e-b821-4a02-84d0-08d9a941f096
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 20:44:52.1401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HvimN8KZT1YDs8Yct1SCWu9+iwoTFtgwt2Pfe/mglcTxXLsV93Eft4cF4jiqSEyPHipOSZvpYBE2RfEZmsP9lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTExLTA2IGF0IDE4OjA4ICswMTAwLCBDaHJpc3RvcGhlIEpBSUxMRVQgd3Jv
dGU6DQo+IEFsbCB0aGUgZXJyb3IgaGFuZGxpbmcgcGF0aHMgb2YgJ21seDVlX3RjX2FkZF9mZGJf
ZmxvdygpJyBlbmQgdG8NCj4gJ2Vycl9vdXQnDQo+IHdoZXJlICdmbG93X2ZsYWdfc2V0KGZsb3cs
IEZBSUxFRCk7JyBpcyBjYWxsZWQuDQo+IA0KPiBBbGwgYnV0IHRoZSBuZXcgZXJyb3IgaGFuZGxp
bmcgcGF0aHMgYWRkZWQgYnkgdGhlIGNvbW1pdHMgZ2l2ZW4gaW4NCj4gdGhlDQo+IEZpeGVzIHRh
ZyBiZWxvdy4NCj4gDQo+IEZpeCB0aGVzZSBlcnJvciBoYW5kbGluZyBwYXRocyBhbmQgYnJhbmNo
IHRvICdlcnJfb3V0Jy4NCj4gDQo+IEZpeGVzOiAxNjZmNDMxZWM2YmUgKCJuZXQvbWx4NWU6IEFk
ZCBpbmRpcmVjdCB0YyBvZmZsb2FkIG9mIG92cw0KPiBpbnRlcm5hbCBwb3J0IikNCj4gRml4ZXM6
IGIxNmViM2M4MWZlMiAoIm5ldC9tbHg1OiBTdXBwb3J0IGludGVybmFsIHBvcnQgYXMgZGVjYXAg
cm91dGUNCj4gZGV2aWNlIikNCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoZSBKQUlMTEVUIDxj
aHJpc3RvcGhlLmphaWxsZXRAd2FuYWRvby5mcj4NCj4gLS0tDQo+IFRoaXMgcGF0Y2ggaXMgc3Bl
Y3VsYXRpdmUsIHJldmlldyB3aXRoIGNhcmUuDQo+IC0tLQ0KDQpBcHBsaWVkIHRvIG5ldC1tbHg1
LCBUaGFua3MgISANCg==
