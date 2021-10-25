Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540AB43A3BB
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbhJYUC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:02:27 -0400
Received: from mail-dm6nam08on2081.outbound.protection.outlook.com ([40.107.102.81]:37280
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240376AbhJYUAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:00:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8bSYcsd7Qo6UsKw115nybQPPq+pAmmUQdBkBR1cRtVKNB6h+zfcupB8F5Kj0Sunpiwo1L1PoaTRCLlKL6oiDvU0va1zBPuFV+3MMXlR0Q21nodrfD0uDd8jwi9z/4OyrPCzEwFNKDyUCinpjuSq/AEkekESPfC+D69eq1S10+BHPHxSUw6Z0v7NWvBCVZ7KocuE4w686AdCGcZDg1UtfeeXC97B4/JDq2PaDuz5SLfHEBUI6AVAvsWX+HejGe4YSjeT6Jx1dVGGkSZQuRNM/hlEAAfQ0P6iRz81AOJ+Kk0xZNtbPdz/NE50lZmrqaA3sgda1STk4LhoeddqD4Vh6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTZTJMclb0pindFbg00B7B+0dLIlzolAELEO/enFvgw=;
 b=caWROYrIdxn8GOlV0JWwtnr8SEf/ukVBZB/LRfee9WSwmZbFrvZlJfnbx48Phhh6JpNkYzXPtGlgt998/JlFUIgC4G61uE/gD0FGwMw1gRAI2awSYwGFnrdfkIuish8/8o8vDepwSDhT3G6B6watimwF3ZdYWJFgcO3KAoHi8zTpt6yNKq4PRCePqgdYDiAv6r47jOt/NC7a+4y1W5Ap59KCszQCilRsxDp6FGZcy+0tTC8gpJaXiC5DRJ1pt2gfvPKczyJKZP7icXedXrD2pfBE71ekFjWpbpUopYw1WK6AyM9bNw3WlSDnv8E3qxizA80lsL6Dk50zuPMvsR5geg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTZTJMclb0pindFbg00B7B+0dLIlzolAELEO/enFvgw=;
 b=Vf+UaIdzFbvRJKtr2QwSq6swoQe3aQFvtHUkvCExLSTnYdgT9MxuoGzouyxT6ioVorfFItp/72XEbFdeUz2mXuCCdn/kkD9G1wjUPM1421SI4+FIOlsouEDZvaasPBfyue4vjIn6w+ICb7y1k+n+ULSdkgPxtxhvDL5ZbUmtKEJg91o2bQ9d0haBAcoZjOBHKAURnt/DPYSz/0+FOrwCkDAa+w7OdAdQg0uvaU/rkE5WCIrH7XTHneMxjUxvpr9RYdXM5lu/dSQsxtk2pJYf0N3jLsYW6tYW7s67ykJm5MYUMhB7ea68gvL4cHr6M5yI0oncRjHpYdavUzjerFTdqg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB3859.namprd12.prod.outlook.com (2603:10b6:a03:1a8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Mon, 25 Oct
 2021 19:58:00 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 19:58:00 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "arnd@kernel.org" <arnd@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Moosa Baransi <moosab@nvidia.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Meir Lichtinger <meirl@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5i: avoid unused function warning for
 mlx5i_flow_type_mask
Thread-Topic: [PATCH net-next] net/mlx5i: avoid unused function warning for
 mlx5i_flow_type_mask
Thread-Index: AQHXxxCnQ3VftzWDEUer7hjtcyQX/avkJxaA
Date:   Mon, 25 Oct 2021 19:58:00 +0000
Message-ID: <4b739b07711c5cb29664a288b8d8a2693d7abf9d.camel@nvidia.com>
References: <20211022064710.4158669-1-arnd@kernel.org>
In-Reply-To: <20211022064710.4158669-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56a30908-dd46-46d4-45e6-08d997f1bfb2
x-ms-traffictypediagnostic: BY5PR12MB3859:
x-microsoft-antispam-prvs: <BY5PR12MB385941B2D0564216F455BCB5B3839@BY5PR12MB3859.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5AaZZyhcVN10Vuvi+6FZnWfIu3+W9I6+cHmu7ipjSrZkbVhVRlF4jxLJz5G4SmWD59a8YPeaHd3/LupJFv0ARA9awO/vvtZjUjlS9MIrtu3E4M4B7XMkF8InXBjdJJu2nUkvU9+gIe4yLSdLIWxyuyvKwQgWGvorbBvNjM/1HKPwAUiimk47/bwWBZk+MDL8mF4Ou09UXUcZJ0puCmUYDGMvO7AlDrSm0KjRbr39lPnvXB8Qt3YsCLqO+sc8DkBtmaU/orVdFsgHd8oNtU+lSgwQRhXNq/In7LV7tzdeI2PnRzD/4/+CDtf/oNdwX1GQCJH/q3UNHXBphKDTsUFsTF2SroSqT8xdXXJ/P6UZQBZ0XbEsTsc1ij6l6ddpK/o1P4/FnKP+ioN9id8Ge9Pg4iNaPsU2l8cZYmXbR+dGnCz8rnLKQV9DZnaWEKMEcN+Mm/gUAd7tp4UkCwB/KXntMXq4QXkhZXwmrq63F+AedWpsfPWJA/aadJpm97+uFRgk4E3ogOAUwwGpr/UXGo7jzh4SwoExFwtlQhy3qe4xJA9K/ShnQrhsPt/WU7B/dSBLzHeIBXKZYIFp+e95XekjJsKa3EJ0pFrwcJQlUdyt9sPakN3pHvjz8UF86CSzg0wQFEzahmIscDP3i1zK5huAT2z7FMg8sXHgw+alQx9EunG6cCnO+eLnxdBC8U40JCTqC9o/gKf5g44H2a8z3RG5hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(66556008)(4744005)(6512007)(38100700002)(6506007)(110136005)(122000001)(66946007)(66446008)(6636002)(54906003)(86362001)(2906002)(64756008)(8676002)(8936002)(2616005)(71200400001)(508600001)(38070700005)(36756003)(26005)(6486002)(5660300002)(186003)(4326008)(66476007)(4001150100001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0xLd2lUa25lbVlVamdlUXVWbVg2R1hZMVRyUzR1ZHpqZ3IwWnAvTGJYbWxF?=
 =?utf-8?B?K1FPMWlwRWtWOUVqeUNOREg3VFdrV3RSTk1yQUQ3eWtlYndWQmUybXFwOUpi?=
 =?utf-8?B?dUpVaUo4UlRYUkRaU05CL3RFc0FvSTh1Tm5WTnpBTWZNazYzU2p5T05wRFJt?=
 =?utf-8?B?MkJ0RVladTRRRSsrckNHUEhQVHhCU2E0Z2NNNVRSQ0JIdC9TTHRZTzRlMWx2?=
 =?utf-8?B?L0xaamdGQ1B0L0YwWmsxU1RGdW5UUERoNm8venRuNGZ3MWZiK0xHTDNXQXYr?=
 =?utf-8?B?MnVoNytZOGZRbmZxamprb2NRWTJYT2w3SkVkMU5Wd2ZvVmJPNW5OeTZRM3N0?=
 =?utf-8?B?SitmTWpWL1lkeXZEMUFpVU85RHJpSzM3UVdYOVUwREs3MkhHYmYxYUUxSDdE?=
 =?utf-8?B?RlQySVhnQWtESGJlYTJyWENFY0ViTGk0Z0dpZS9rZmlGN3RPYkt2MDF6VlJv?=
 =?utf-8?B?dU1wVytTZUJFU1VocjZVdmVUaTR5bjBNVTFqczhQRjU2Z2xOVGFjYVY2ODNr?=
 =?utf-8?B?QjVWZWMzR0ErUDVCVm4wWGxQdWtocXJZdUFLdHYzZkdYK2t5bEdFQkk1YXBk?=
 =?utf-8?B?WWJpK1BRWFJ4amx3bHBBQk1iRkNpekR3enUxTEEzTmpZNDQzS0E0WDNuSkMw?=
 =?utf-8?B?QmtsMzE2M0kvODlxY3REUzl4TW1IZW9TZExXVFNwWkhvNWhLM0pQUW1NNnJh?=
 =?utf-8?B?cnVUZWYzTHpYNkpuaGFRY3BPYTE1NlkzODU1R2V2MDNhV1VQS1VYTFh4bi9q?=
 =?utf-8?B?eGdzWWdoR3ptWExzblRTNEVzdnJwMmhib1J2UTdZZFNMV2U0NHlNQ3h5Ky9r?=
 =?utf-8?B?bWpzL1psT0llZ08xV3BWTmVmOHU1RGU1V0FlVTRQT1o4UjA0bWRla0hkZmpN?=
 =?utf-8?B?cFpOM1NBSHlqQVRiSWFjazYvYjJMTkpiR0hpelV5Uis0MUE5NFVLazVQZXk5?=
 =?utf-8?B?cGFPTVgyNk41R3VFZDUxQ09DMkthQzhpMEgzVGdGU1B5OG9jb2NYcjQzUmpY?=
 =?utf-8?B?NXg2eDRUSXE4MCtXSFlDYWJjeDFGa2JoNGgxc0N0bmlPSG1NK0RlZUhGYjN1?=
 =?utf-8?B?bmxrRGk0UkNiYjRlRUtFZ1hWc1IzK09vdnhRUElxc2ZyeGlEWC84a3lkR2dq?=
 =?utf-8?B?ZnNQemovanprNnprZEFGTGJsWWFiRDVndTZyU0FoNkViQVZkMXltOWQrNU5s?=
 =?utf-8?B?NmNhcWMzczR4TGdWQ2h3VUp3ZkYrSENMYzR4aFBVZ0FyM2RvS0FkVjd2M2oz?=
 =?utf-8?B?cWg2NmZESzZsU3M5YmFjM3FmWlM5ZXNENVNOSU03T0tiOWFKdklGVWttN0Vj?=
 =?utf-8?B?Z3J5VTMydWVpWG5QdEU1RWttMUxyQ0tIcUtZTjNUa1JDRmdGR0Y4WTdMaXpF?=
 =?utf-8?B?Rm10N1I5ekU0M3JBYXlHZ0E3b0pscUxWc2drMlprOW5mYTY5OEx2d2NtUmFl?=
 =?utf-8?B?eUdwZUFoeDdyOVZmMTVxVW0rRVVOd2dUQWhZZ1pRUDlRNUp2T21BS1NIZDVr?=
 =?utf-8?B?cXByMGJKQ3Q5VXpVSDRubmV1d2pieFNYOHRZZzJqMGN3WEVpVnY0MnB3enlH?=
 =?utf-8?B?MHlSUXpYSmtNT29EZGNHZFpKV2RLOHloOVlzempQYjQyaVhXeTRudkZ3dzEv?=
 =?utf-8?B?RDlOOVdPazFINnpkVWtQcmczQTk1S1pVQ1hDOVJZWmJpbk1LVmx2eHNCbGJ2?=
 =?utf-8?B?WTNKUyt0Tk11Q3d2YTE2bW9kcjl5MkN6TzJleGwreGN2aFBhc0x0aVBLbG8z?=
 =?utf-8?B?eXZkQmdta0JoaEh2MXJYSmNlVkR4azU4V1FTYW1sOHBFWFZmWHhZV2VGTTFB?=
 =?utf-8?B?T0RLZ2JYWHFmdzBBZmxwazJYV1lUcFMvUDFqVmFnRGdVWnYxRmFtTjZTOTRl?=
 =?utf-8?B?MHF6MEdORENrbDZmRWpEQnd1YUwyWXFRc1pCb09wNzVndlptY2tTL3RRRVRE?=
 =?utf-8?B?ZTFSUzdGLzlWZnk4QUI2MjVPbnBHZjNjMW5rdkpudklIZVJWZjBtYUJBKzRG?=
 =?utf-8?B?UlhrUnF0cjFTeEdIMjB5RElUUk1XUWREWHlTc0xEa2xBV3FUb3EwdGtudmRD?=
 =?utf-8?B?eUV4MC9UaStIZTYvanp0c3kzQkdZTmtSVWZaNXB0V2dFT3hrQ0xSMHNGaTFw?=
 =?utf-8?B?aHgxb3c4NFd3YmZ5RXZrR3dZVVJDNXVSREtHYStRZkE2MlJUSjl2eStFL2lo?=
 =?utf-8?Q?ydelvzKqq2bjLfl0NEBQgcY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4C02AF46C744148BEAB1911A5DD4D81@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a30908-dd46-46d4-45e6-08d997f1bfb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2021 19:58:00.7883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ltK5o2rKaGxSu6byU8/H4XK0LfoAfESWmZty85fjTaes5oz4hbHEw/brK2XisExP5LIAtpufuYeLpxi4nkOMFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3859
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTEwLTIyIGF0IDA4OjQ3ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiANCj4gV2l0aG91dCBDT05G
SUdfTUxYNV9FTl9SWE5GQywgdGhlIGZ1bmN0aW9uIGlzIHVudXNlZCwgYnJlYWtpbmcgdGhlDQo+
IGJ1aWxkIHdpdGggQ09ORklHX1dFUlJPUjoNCj4gDQo+IG1seDUvY29yZS9pcG9pYi9ldGh0b29s
LmM6MzY6MTI6IGVycm9yOiB1bnVzZWQgZnVuY3Rpb24NCj4gJ21seDVpX2Zsb3dfdHlwZV9tYXNr
JyBbLVdlcnJvciwtV3VudXNlZC1mdW5jdGlvbl0NCj4gc3RhdGljIHUzMiBtbHg1aV9mbG93X3R5
cGVfbWFzayh1MzIgZmxvd190eXBlKQ0KPiANCj4gV2UgY291bGQgYWRkIGFub3RoZXIgI2lmZGVm
IG9yIG1hcmsgdGhpcyBmdW5jdGlvbiBpbmxpbmUsIGJ1dA0KPiByZXBsYWNpbmcgdGhlIGV4aXN0
aW5nICNpZmRlZiB3aXRoIGEgX19tYXliZV91bnVzZWQgc2VlbXMgYmVzdA0KPiBiZWNhdXNlIHRo
YXQgaW1wcm92ZXMgYnVpbGQgY292ZXJhZ2UgYW5kIGF2b2lkcyBpbnRyb2R1Y2luZw0KPiBzaW1p
bGFyIHByb2JsZW1zIHRoZSBuZXh0IHRpbWUgdGhpcyBjb2RlIGNoYW5nZXMuDQo+IA0KDQpIaSBB
cm5kLCB0aGFua3MgZm9yIHlvdXIgcGF0Y2gsDQp3ZSBoYXZlIGEgcGVuZGluZyBwYXRjaCB0aGF0
IHNpbXBseSBtb3ZlcyBtbHg1aV9mbG93X3R5cGVfbWFzaygpIGludG8NCnRoZSAjaWZkZWYsIHdo
ZXJlIHRoaXMgZnVuY3Rpb24gaXMgb25seSB1c2VkDQoNCndpbGwgc3VibWl0IGl0IHNob3J0bHku
DQoNClRoYW5rcyBhZ2FpbiBmb3IgeW91ciBwYXRjaC4NCg0K
