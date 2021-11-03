Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69F0443BE0
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 04:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhKCDgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 23:36:51 -0400
Received: from mail-dm6nam10on2083.outbound.protection.outlook.com ([40.107.93.83]:6258
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229506AbhKCDgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 23:36:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afxjRYP8KeYB1KMN4Z7x0g7GHqO3eNpJ1L6ADV2mTvZ6Z58rWb2Qv0Xxw2yZBjlA9Hr0i2zxQU8OqGVmxOJQLdSKy71iI5E+haKYwJrrHDUpxjbNJ+UpeGZN50ZDKz/8Yp7fMuTBZA9fNVE8gA0gBwJNkz53FJOX1HWfkiKwY4y9ABBsBShPkyGc/5i0FctRrIXJYaku2tCx9LuZpGky8KyZf/Zmhl1PUsULY2+22AeIsI5ZtNhEflqyq6EOWWwHYqcTafEokQlZiTUkiBf2mr/f0XhrtLfTJvtJRpDtsLqVIZc3/+vi/VmBpHOl8CyvO1GBQQznqb5entPUIW+Jdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chRKd0Eep24pjB8a3TGfdK/frRr3jxfc19n7bN1yFNw=;
 b=NLBnXNrayKQVhObOFx/hYxa/UBS7bwXy4oQXdXVbsVrBKDa5F+AehOht+hlR7gDQeLjOpymHpagQTidhwc/EpXSD74QVRZ5oc+RR5smUbOsKISbofS/yHz+He+oHPzVPW7OzkZUYAVmRgn0GKsPupKpX7RiX+nXNPsmLcru9mcKeMSYpGCJWes4f8lj4hAUDDTK/STDqnPR/e7qOCT/PwhcXgRJww6r7D7/KoA2MC7rLtD8eipf1kgwoDNBMp35DyfJCv0VdNtk1B1weQqPqz/6zEOpncpeBmX3GRybHP1IhouOeHuUggwZdaA1pXzgGNdip3k4EFstk1c3FJnHtcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chRKd0Eep24pjB8a3TGfdK/frRr3jxfc19n7bN1yFNw=;
 b=Dxh/cNxsxHr/XPIpVotoC5/JjRvFOGYewTyLEiRyQ54YgJIaT3nguQPKNMkP8EUC0wivfx5eVS3k8cqiUiZ/VvSviTrfNij2QnI6JbEW8pAdATgvoNZ3E2g5CsxhdrmWdsk7OTnVlSEqZp+10PQpdnWX0FqeZjau7YpVv1DfHGG/Bs2z0M1HZrM7PK2hN8kV8R9JKDtZdm4YyS01xpDnL2YDHLhDjA/GUXNfkVYuSGlalvVqkeN/rh7dcpw0GkMsAXBIiCuQ0GgynBxiAioRL08BfPlm7jFZszAkuOKSI+F0jMOOM4q/Nufb1A8Pk7OM96ihGrRKJxsBsQZ1K4sMgw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2709.namprd12.prod.outlook.com (2603:10b6:a03:6d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 03:34:11 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4669.011; Wed, 3 Nov 2021
 03:34:11 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net v2] ethtool: fix ethtool msg len calculation for pause
 stats
Thread-Topic: [PATCH net v2] ethtool: fix ethtool msg len calculation for
 pause stats
Thread-Index: AQHX0DVcBrkKf6+siU+t9DxnsxxoeKvxJuqA
Date:   Wed, 3 Nov 2021 03:34:11 +0000
Message-ID: <9f256591793eed8df78fe0f610a5d6aeb4322173.camel@nvidia.com>
References: <20211102220236.3803742-1-kuba@kernel.org>
In-Reply-To: <20211102220236.3803742-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c456714-dacb-4afd-8e64-08d99e7acd66
x-ms-traffictypediagnostic: BYAPR12MB2709:
x-microsoft-antispam-prvs: <BYAPR12MB27098BFBA8EE497FC067441CB38C9@BYAPR12MB2709.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OiXKQvZUEYfQDugZqe6iajFwN7lLsAAHFJNp1iXuNHesQLpPE4WUG/AsjraB0A9WOWdYMmiCMq7wejz4OBxgZ58AoLMoFYE8tb7y60YDlzDvobtnBWclMj//VWoYq2QwAs8XWksqj/93y+z9RRiu+dXp5BrRuGt+vuSAG7QjN/t7XkS3y0impjHmhOM/Rat2zc9UnFmCNU6hGOcnNY0pt8Vqf+ZweCgh2b/h2ZPY1zFt+x5lUE/HbCY0gtXuOe/duWpL6X3m+nxV5eV0hAr461t+y8iKexhBq8K20aVojKHn/r2uYdHcvREtCzJPTe13ih+Fz5CtVlmU2xerS111QUoFJ6Kj+/75Bi5AACGITKdtsJEV6ez3ono9Agj4PoFff8/1NvKexCaE5U0a3jeEwnapa4TMfBAQotaCXyFDz1LpLxg8KbbhWrqCwGx4twWDNNUqLAlNagsTfj0RhBxrD9W+k4W1NQnTfM1w+p3U71kuF7KSvFrDr+LW4J11FaTVT+il6TM8hv/WRzGy2Cb27/66u8CdZd2huRiSocqYG/v4rg3PJXGJVAp0Vlc5k0L2f+1jstvjehVbAUdIOL+3qFYON/mO+z+mMSm7KL/9VNfm/RZYD58W6HjpmfpWmHFyiHcYMEq7OoomvrnFQZ6rnFtX8L7VuUgXfa6RGXtLlpjkbesisKFZPI40jLE6ONHOQnfgFrg7MrzjzBWFr+0oqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(6486002)(71200400001)(4326008)(38100700002)(76116006)(8676002)(122000001)(86362001)(5660300002)(38070700005)(508600001)(66476007)(66946007)(66446008)(2616005)(64756008)(66556008)(6512007)(8936002)(4744005)(186003)(54906003)(316002)(6506007)(110136005)(2906002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEVpSUFOVUJjcXcxejhiMm95M1FTTktESDhwUGxSUDVTM0ZLbS8rZnloWXRK?=
 =?utf-8?B?TzIvVFlBMXFnMFJMNGpYNjhjTXlDdUcyL0MyQzhQK1VHV2I3bm1JVkFnZzAw?=
 =?utf-8?B?d21zbU5nZWswSUwrS3l3Q250M2s2WkFSdzdlRWxRLzJKemZ5dGpLMlhpR21N?=
 =?utf-8?B?MUpTbEQ0Tmo3am9OaHg5eFVvaFRpSm5vSzJtSVVHeUpaR0d3OUVCeVJKNUNS?=
 =?utf-8?B?alVnSC9qeGRWaksrMTgvL3pZT3IwM0o3VFpHakp4WFZoWlVYckx6VU1zOE8v?=
 =?utf-8?B?VWp5b2gyRWFNR2xZcWtRN3NxaFZ3VVgwam8vYmxlbG1RUVBlYkJobjd2eCtO?=
 =?utf-8?B?Mm1IOEZIUFUzN1QvTnNLUzBrK2tOSTV2a0pvbGVhVGxqVHBMY1k2dVBseWhS?=
 =?utf-8?B?U2tDZW1pSzNoS0NBRDVGcG9NTWJUblU2a1R4aXJFdmw4cEk0RkN0VWgwSWo0?=
 =?utf-8?B?TDdZVTcvQXN6UHVZL0FoeXEzQkNwYUZOTkd6c0trRjZ6YStTbHhzcWFZY2NR?=
 =?utf-8?B?c2hBMk1SRmxYenhxL1pOZStpL2x6Z3lUYnZYL2NFS0ZtUGlGTm1sM1FPZURR?=
 =?utf-8?B?MFd4UTllUmllTVFVdGZGazR3TExFbnVJOStzeEVOUlJQK1NuVzFKeWp0YXJI?=
 =?utf-8?B?WUFEZjRIcnRGUGdUQUIzUmJadmdta1FRNFdqcHlIWHhGZ2xvYThxdzdyblVG?=
 =?utf-8?B?TnZFVXNycEpWaHpNUGMxQU1WTXN3RXNSblFVSitEQWliRGNscDZURzFMU1Yy?=
 =?utf-8?B?OUdXRVBlTUZmUjZDUVZoeXZjSkhKL0NwSXgvY3V3NC9YV2h1bDJ2ejNBK0hF?=
 =?utf-8?B?bGtmSEdRbC9IdWFTK3VnZVd5ZFQwbC8xbGRhaEpOa1lyM1d6ZzN2MTNyOGha?=
 =?utf-8?B?ZzZVQmJGQzFLOUFuL0djTUUzanhvUzVRNU5LUjltc3pzaE84a3dCZU9YZTlr?=
 =?utf-8?B?bHVtc2lxS3RoeHZ3SFhKcDhDcVV5MGNZYjlsQXdqK0hxZk5BOWtSMjNNdE9X?=
 =?utf-8?B?REZKejVIY2Q0TkZtYTBpU1Z5UEdldmduREt3QTF2RnBHWnZKTzhZdXB6dis1?=
 =?utf-8?B?SDF3SmxNNHNJY0pTblN3WG1tWGFIWFZqWW9FNU1BL2Qyb2d4T3hlc1NKSXgv?=
 =?utf-8?B?dVh1NmFwT0NKei9maVl5eWI5UzcwTGxQSU54YjJIUkRlcXZwcDRvNGlkTFhn?=
 =?utf-8?B?enRUb2ZRR25lQnY2blhHNWswT2pTOEVLd3AvRXh1RHBPQXFqZ05KanN5Szh0?=
 =?utf-8?B?NEhPT1FuM21hQVNsYVY0VWF1U05uTk5iRlFWbUFaWm9vZlRYS0ZXWi8vQnZw?=
 =?utf-8?B?NXV4NEs4ekxkYVhTelhJS200NThkNEFkaSsxN0drQ0tpRjdTM1NWVDhqQXFC?=
 =?utf-8?B?QjlqUWlQTWNpQzVxYWRnaDE3NHgxOE1BVGVlemNPMmlLZU8yKzdrZUc3eTFV?=
 =?utf-8?B?WVk2RnFyQ0RmcjlHZTVYVDJMTnRURXM3MHlDTm1SVkdCbHhWSGpCbDUyeWVu?=
 =?utf-8?B?UlQySFpoWktyNG5WODRxMVlOLzRmZm1mYmYzWW16eUh4SEVOMC80MUxDSjND?=
 =?utf-8?B?SXkvRlRmeVlFWW54cWthWHN6MVRIS1NTeW1kWEVjWnhjRTRxbkNrYU92YXdF?=
 =?utf-8?B?all5WVFqVTJzbTBiMVpNckZma1ZtTW1BbFk1dDRFNjVvZzZyUU5WdnJ0S09H?=
 =?utf-8?B?WnFwaVdQMXVwbjZ5R3R4UXUrc3VzcWZDTWxQc1gyZGs1QmpuUzJZZE1NOEVM?=
 =?utf-8?B?WFQ1M2M5STE2WHc0cDlzWnFhbnVhREhHK0FqSU5vbU5xYnFOOWlFV2xDNCsy?=
 =?utf-8?B?Y1FqR2xiamNIK2IxMGl0ZHQrdXNLcnNjWlBZcHA2eFhsSjFJZUZBRDNKTUZo?=
 =?utf-8?B?bnRpMWlWVHVBRXhCTWNYQ0JSR1R3eHY0dGRIc21LV3FDd2Jmd0hSQXR3cUdt?=
 =?utf-8?B?RzNKOTZxSFJxQlcwMUZBSjQyaXFjSmszY2hwUERUZVhJdjFBeFNSWlNTWloz?=
 =?utf-8?B?aFAyajFkNllDZzNicjRETlFGbHh1K2pYWlJhSlVXYXpmcVhzd0FzQ1RGV1Jm?=
 =?utf-8?B?Wkl4ZWs2RjBkZWpTd2dJbThwS1BYaCtLZmR6WHF0azRrUkJNOEp1aHVmalpo?=
 =?utf-8?B?R0I0VGFoa0R0cmF2Q2xRQjV4S3FPSVNud2h2MEpORkRpSTVtQWZIdHFHMXhQ?=
 =?utf-8?Q?RsSATfC2hBId96lDTTpjvoNu5NhqCoMlFcz1kxixXoqC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36A959D0B051494DADD371400FD8F0C5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c456714-dacb-4afd-8e64-08d99e7acd66
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 03:34:11.7361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NZDxVUEbIAzqaTVlRxC5wJ3HbLzdDTzf1UJvdfWHPhgV5F4ARX2406P6j0BBEbpy56r0UN/hoGF5vEq9mfnELw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTExLTAyIGF0IDE1OjAyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gRVRIVE9PTF9BX1BBVVNFX1NUQVRfTUFYIGlzIHRoZSBNQVggYXR0cmlidXRlIGlkLA0KPiBz
byB3ZSBuZWVkIHRvIHN1YnRyYWN0IG5vbi1zdGF0cyBhbmQgYWRkIG9uZSB0bw0KPiBnZXQgYSBj
b3VudCAoSU9XIC0yKzEgPT0gLTEpLg0KPiANCj4gT3RoZXJ3aXNlIHdlJ2xsIHNlZToNCj4gDQo+
IMKgIGV0aG5sIGNtZCAyMTogY2FsY3VsYXRlZCByZXBseSBsZW5ndGggNDAsIGJ1dCBjb25zdW1l
ZCA1Mg0KPiANCj4gRml4ZXM6IDlhMjdhMzMwMjdmMiAoImV0aHRvb2w6IGFkZCBzdGFuZGFyZCBw
YXVzZSBzdGF0cyIpDQo+IFNpZ25lZC1vZmYtYnk6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+DQoNClJldmlld2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+
DQoNCg==
