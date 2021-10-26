Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D865E43B62A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbhJZP44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:56:56 -0400
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:46144
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235747AbhJZP4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 11:56:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDVSu1TwzUcVepPCt5p0J416Jo5KVyfoaG7PK5JBk6AvEG+vESWpMV4Fx+9JAibAI/CFBbVctnhtMPUC79TcyMOHODPn/xkkkmCia4q1XxdSxI6GUkx1TZLLOMhmKLzrRgwK3xyTOdNgmY/N9vkmWy6SxA1Fi9wnZr7clNgoONQ7qEirSA3h8NPZM1RM3Cu/z477jslYJioZstntyxNilBLqPzHFpt1U4tkAQpjUS0Xa72jeLk0E7SHrUYFRONcziB9hKDd/wQlgA/BiFkUzeYZMFa8EiPWnkVn6ti7decybOlE01vM0qYk1BFVdbwabzTggrr+na9kh+VJfQ19aEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJghEi6eHmjonr04myiv8OzhNNXYL4G2cBR0y94U/So=;
 b=NN2yxFmaZ6rYGo/3D4XMkDxgI0D6iAbR+vfR9gFfvMqQ7D8Mt1qhkgsn8HV/KcFVP3dw6OcBnzW01Q9CVGdv3eUvMxbesg9kCOUyOjNjDWGQI5DcADVRup0aAdXdXjgJg3rVWHPEVx5Wzc7nnRNNjft/5SYiU78soJDyCHcXHUGAyixeSF4jm+wuXTq3MKzPTMW+zHHpRQwDc16f9eYt+KjynbgXfXhod4FLsniHVU40qHjptmBO8G7WQKzolJ1lDrOiqnPIfFjdrm0gQ3KLzU0Dd/z0fnmqoemqcImuIhY4fL2mPYYeJHrim9LokUxS7gTpRxqVBt0IfsqqjpHRjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJghEi6eHmjonr04myiv8OzhNNXYL4G2cBR0y94U/So=;
 b=cW0Tg52XJlqb8QJDSGH8jEsXPXEKM/yKg5ckmGcJvxjqZHDMNlHQPgyGPa6kCe4T3CNAO8kv1LValWR9XCOJTmC/Zzz5JT2daaXLLw4PLreGrq8uh/SxcajVmP/dAir0Pn8rNI4eoGbZlNAsXVXPof025qz5dkMntB5WYAeDJ+05X7N/XZV3+GQMD4+K8rPfu2Jn9dx+1yu5y7tlPCzMZLMdbfn+VcKBu0alqGQ5UKceDSH8T8kPTvF2G1Tnc5HO128qEUV9NkQzLwBPZ9XtTCQVAOPkeMA/lBLO1nUA8AOHP2hGgOjI3ebrKkoxq6lZv77cbpHhSKueOzf4wHf1yA==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3350.namprd12.prod.outlook.com (2603:10b6:a03:ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 15:54:29 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 15:54:29 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jiri Pirko <jiri@nvidia.com>, "kuba@kernel.org" <kuba@kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 10/14] net/mlx5: Let user configure io_eq_size param
Thread-Topic: [net-next 10/14] net/mlx5: Let user configure io_eq_size param
Thread-Index: AQHXyeKHFUDDWlwOwkOu3+SfyDMHKKvlYhWAgAANqQA=
Date:   Tue, 26 Oct 2021 15:54:28 +0000
Message-ID: <91f1f7126508db9687e4a0754b5a6d1696d6994c.camel@nvidia.com>
References: <20211025205431.365080-1-saeed@kernel.org>
         <20211025205431.365080-11-saeed@kernel.org>
         <20211026080535.1793e18c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026080535.1793e18c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b40a47f-61f9-4e6f-c2c6-08d99898e4cd
x-ms-traffictypediagnostic: BYAPR12MB3350:
x-microsoft-antispam-prvs: <BYAPR12MB3350D2A739AA361CC6B69A49B3849@BYAPR12MB3350.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M9WeQzvTe4QDAnA790LwLpKABw+r7FF29MaxsMAiadXpKl0xtrSjHlA2mP0QHK7L4G03u9gNNxoKhF8xML0QSayyX7mHrXicfIlyiSY0eUHlQREWpfeCv8SToU2QSpphfrcKEMkjJCGG7tZGqsEfYICL9KglRnrP9Vf+TVpHVB8uUXTQyDi0Ao4zE4tXzrfsiO0YaEm8++D1g6438ZgzXsmL6DYIVbrrHIhIDzMMq4F51UNLbjUpG4XTfiDdBH7dbnxS2SMu6iD1q3B0XW5M2KBD7lS/wW8MDMZJ5Iahd5spzoYIzKp6ZQUSH7Zw6IzJqcuzxQgKsMz2qeu7n2qT3sVkKy3LllnUiGvCH7gzWD542dS5tzWPAc8kThwHnO9UnzlzddPrTg0mguTpcvS36wr+4FzV6FB8cwX9yq+RVAK4qL/2qXCe23V5bOsNg4rD+DegHRT27cnmv0v2W5RYB7OPcRqw/YF2PTtUGiQrl+iLM+qv0Es8t4uvcGbJkI/ahwpVlZu0SzlwCprVivm3GkTEJy5WInvExlIqACbqa0hTnxIOaWdDZCPTRi8oUHlrDHN1ucYP+O2KeM1j3pOu8FILIGCjSF0elpBvQ17BQv0kOK0iT932RVf5gXXyD95GCJ/Vt9pds0yUn4cztOndQo9uieFDQx1SR2TV+5fpYlxDNnWU55ySiVk89Yxn3GnA/dgMa3UlZ0872O/MFqUq8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(8676002)(5660300002)(508600001)(4001150100001)(8936002)(122000001)(71200400001)(86362001)(66476007)(66946007)(6512007)(76116006)(66556008)(4326008)(38100700002)(66446008)(64756008)(110136005)(6486002)(186003)(6506007)(26005)(316002)(54906003)(36756003)(38070700005)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTU0OXhDakMzbW9rUDBIRDVHalJDQ1dDWS9QNXhveUFlSGxKbFZ3czJWS2s2?=
 =?utf-8?B?NjIwR0J2SFRFWk82d01ST0dzUHZDS2h5NU1BRXY0N1d2V1MxL3luZjE0d0Ru?=
 =?utf-8?B?dTFhVHVUNzUrMmU2VERrczFWcGF4Ym1CVjYwcmp1amh5TjVXUEZORXRSdW1Q?=
 =?utf-8?B?NEhDenZjVkVQVmJiQ3lMVS95ZU9odXpuWWxOUHpzYWtkcEtMd1BMbFo2TUcz?=
 =?utf-8?B?ZkphL2d0MGx1TjYzdWZJMkxRZFAyMGhqRUJTL1BlczdPOFZ6dTYzRzVNcjJR?=
 =?utf-8?B?Z0dGeGkwVndRS0F0S1lEREh0SXh6YjU0L0pRYnYyWVpxTmpjWXdiemdsWlBC?=
 =?utf-8?B?emR0ZGJpbXhqMmdOMUZiYVBJcCt1b2I4akxBYStxNXdSdExFSVlZMlBpY3hs?=
 =?utf-8?B?aHRTbmEzNlllZEY2NURIcDN0UFVXYnlrN1FmTVNwNVRzd0VVNE51T2x4aDFO?=
 =?utf-8?B?UFFxVzdmQXNZK05uOVlvWk0rNU9vNU9tejJhZ1pxYVh2NXdzZWVQdWYzTXFB?=
 =?utf-8?B?ODhHZnRaVmZhVmg3R3lrVjJaUGFjTm4rMWFXN1AwVlMzYmNCTmtVNlMyYUhy?=
 =?utf-8?B?dGVuSTBFWWJaT3c2T1FCUDd4Mmgyb21UaHZoVHZZY3Nnb3dqSHBKVHQrQXc0?=
 =?utf-8?B?VFNCSEhVbG8yZU1YVU04dTY3aUNEaG42QXJwczRSU3VoNmNybE9GSlpuT01u?=
 =?utf-8?B?M3NYQmhwWXVHb2QzZitmamtLZVduSWRnYXJXVGFOYUhsandoc0k2eERJZ20z?=
 =?utf-8?B?MG1oankxVmlENStmOTdIa2E1YVNCZ3NtUlE5Qmk5SjVMdTY5clpyOU1abmZ3?=
 =?utf-8?B?Z01iOGwyUXphUnZmWlJuZTJCNDVKR3RkaXBINkVLWlBwK3R3UW5oR3BSeW0w?=
 =?utf-8?B?VHFQU1V6L2NraGtHeDJzeGNmaWc0QU1hS0VrWmJnODdtQ21WRVJrc1ZXTVd2?=
 =?utf-8?B?cEhVQnR5akZpNGlTSDVaQ3EvRG5WZ1ppTGhDdXk2d2ttYWZkeWU0L0k5QjE3?=
 =?utf-8?B?NWVKMXhtME9CNExESzhHMEVjSzlNTGk0SnRwZ3ZxZVNFVUFBZzgwcW5GR1Zu?=
 =?utf-8?B?d201cWxpdnh2aENtT1B4U3k1VFBoTjF3aUcxelV1TGR6UUZUOVBPQ1B1MnlJ?=
 =?utf-8?B?Qmw3cFRrdDRSaTEwRE5mTENINE5nYjJvT3kvRE1Na05hdVFYRGF6bDQ0NXBK?=
 =?utf-8?B?SFhnck1BT0VHK3BRU0xRazkrdUhGK21zUXRha21RV1JqYms4VUZ3UWkwdHhH?=
 =?utf-8?B?cWVRM1pkeDV0RjhMaGx1bmU3K0FNNEF5QnlTK05YbHhpazY5NUY2d0VQZkNu?=
 =?utf-8?B?KytmQnVFTmNFckMyRE9SWXZtZEZoM3pTRVl3UWd6bG82N2poWGF4N3dIR3RT?=
 =?utf-8?B?WWY1UG5rb1l5dGxsUTRrU0dvdUhNZGRxOGRuUkVzM3h2N083WU9Gbk8xQldF?=
 =?utf-8?B?b1NFYjlVZ29IZ0p0ZGdTUVlvVVJyemRmdTNXRkhTYTl4YUtGVUFISlluRE9n?=
 =?utf-8?B?ME9hcEJlV2VFTXVsRGxLellPazZ6dlNSQUUzSktRdU5aKzMwNWdyNHdxL21o?=
 =?utf-8?B?MVJKUG5DMHloL1QrZ3JBNmQzSHRZQ3pPRHJOZXlmbTg1cGQzdHQ4OXR1TTFB?=
 =?utf-8?B?RzF6ak43MTR2REZMc0dUYzBvK0ZpVm4rVmlUeFZDN0ppWW1JL3BaMXZkeWJW?=
 =?utf-8?B?b2JFYnFxc1hqY0RDamVjNmhFWHU5QStOMldkN1F0dVVzbjgxWk9EV09jMmVu?=
 =?utf-8?B?cUcyb0hUQkFVd3NOSlFJZWxpZGFtTWhMYWV1RXRUTGJFVDE4UXlDME5zTFpq?=
 =?utf-8?B?YTBScTlnNlZ1dFg1cW1tcS9HWGZ0YmszTkdUWSs4cFM5ZmVmTlozN0V3QVdr?=
 =?utf-8?B?RDdzUUJPUlp4c1c3d0Y2Q01id1dCamtJcGJoWHFnMWc1c2tmWkxPOEVlR3kw?=
 =?utf-8?B?dk9jRk5yYTQwUDN1Q2JXVUwxZ3kxSUx4eU52Q0hObWVSU3lsdjU1NlBvekY0?=
 =?utf-8?B?ZUFNSUpoVzI1TEhIL0s4S3RKbmhaMG9PcHhXWkhoVVNzSExtaVZrdVNyM3Yv?=
 =?utf-8?B?eGdkNk9GQ2x2UE5FR2Y4dnU3QUt3TlhYYWh1YzhiZ1JxNUtyM0s1Z2Q2UXU1?=
 =?utf-8?B?RGU1YUxpSUcxVWlBVHR3TUlxL01pVFJpUXJaZEl3STh3Q1FKekQ4MHFDNGVM?=
 =?utf-8?Q?h4YVH81awS2+JabPXwci1UesqNoQ3PUwMXVBZ/hSnkPP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D626845CF444F419EE7E5DC0DE2AD18@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b40a47f-61f9-4e6f-c2c6-08d99898e4cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 15:54:28.8755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WD/RiAhOteJwzncEXdBc7eOGIimdwtLEEfuEPst8UvIL4cKmpB1pkMg9TkEqu2eCXDW4UmDDw4as0nuQGXYwRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3350
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEwLTI2IGF0IDA4OjA1IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAyNSBPY3QgMjAyMSAxMzo1NDoyNyAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBTaGF5IERyb3J5IDxzaGF5ZEBudmlkaWEuY29tPg0KPiA+IA0KPiA+IEN1
cnJlbnRseSwgZWFjaCBJL08gRVEgaXMgdGFraW5nIDEyOEtCIG9mIG1lbW9yeS4gVGhpcyBzaXpl
DQo+ID4gaXMgbm90IG5lZWRlZCBpbiBhbGwgdXNlIGNhc2VzLCBhbmQgaXMgY3JpdGljYWwgd2l0
aCBsYXJnZSBzY2FsZS4NCj4gPiBIZW5jZSwgYWxsb3cgdXNlciB0byBjb25maWd1cmUgdGhlIHNp
emUgb2YgSS9PIEVRcy4NCj4gPiANCj4gPiBGb3IgZXhhbXBsZSwgdG8gcmVkdWNlIEkvTyBFUSBz
aXplIHRvIDY0LCBleGVjdXRlOg0KPiA+ICQgZGV2bGluayByZXNvdXJjZSBzZXQgcGNpLzAwMDA6
MDA6MGIuMCBwYXRoIC9pb19lcV9zaXplLyBzaXplIDY0DQo+ID4gJCBkZXZsaW5rIGRldiByZWxv
YWQgcGNpLzAwMDA6MDA6MGIuMA0KPiANCj4gVGhpcyBzb3J0IG9mIGNvbmZpZyBpcyBuZWVkZWQg
YnkgbW9yZSBkcml2ZXJzLA0KPiB3ZSBuZWVkIGEgc3RhbmRhcmQgd2F5IG9mIGNvbmZpZ3VyaW5n
IHRoaXMuDQo+IA0KDQpXZSBoYWQgYSBkZWJhdGUgaW50ZXJuYWxseSBhYm91dCB0aGUgc2FtZSB0
aGluZywgSmlyaSBhbmQgSSB0aG91Z2h0DQp0aGF0IEVRIG1pZ2h0IGJlIGEgQ29ubmVjdFggb25s
eSB0aGluZyAobWF5YmUgc29tZSBvdGhlciB2ZW5kb3JzIGhhdmUNCml0KSBidXQgaXQgaXMgbm90
IHJlYWxseSBwb3B1bGFyLCB3ZSB0aG91Z2h0LCB1bnRpbCBvdGhlciB2ZW5kb3JzIHN0YXJ0DQpj
b250cmlidXRpbmcgb3IgYXNraW5nIGZvciB0aGUgc2FtZSB0aGluZywgbWF5YmUgdGhlbiB3ZSBj
YW4NCnN0YW5kYXJkaXplLg0KDQo+IFNvcnJ5LCBJIGRpZG4ndCBoYXZlIHRoZSB0aW1lIHRvIGxv
b2sgdGhydSB5b3VyIHBhdGNoZXMNCj4geWVzdGVyZGF5LCBJJ20gc2VuZGluZyBhIHJldmVydCBm
b3IgYWxsIHlvdXIgbmV3IGRldmxpbmsNCj4gcGFyYW1zLg0KDQpTdXJlLCB3ZSB3aWxsIHN1Ym1p
dCBhIFJGQyB0byBnaXZlIG90aGVyIHZlbmRvcnMgYSBjaGFuY2UgdG8gY29tbWVudCwNCml0IHdp
bGwgYmUgYmFzaWNhbGx5IHRoZSBzYW1lIHBhdGNoIChkZXZsaW5rIHJlc291cmNlKSB3aGlsZSBt
YWtpbmcgdGhlDQpwYXJhbWV0ZXJzIHZlbmRvciBnZW5lcmljLg0KDQo=
