Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CF631D215
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhBPV27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:28:59 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13310 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhBPV2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:28:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602c38ec0001>; Tue, 16 Feb 2021 13:28:12 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 21:28:08 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 21:28:06 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 16 Feb 2021 21:28:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofa+B/w21Z2wlTpy+Dng9fLIxh+0eNvVxWSKHVGp9sk9cHHGZueiec2fhAaCtx2hbClOVxSMq/RNKyGujdsjZ8rMvbm83BKX50A+tNNfRPhhwQFQ3odiZKKh5WYeWBP7nQTc2zoYUEmZe8Wwap9V1UkPbtV7RrrfWvkDRVAlOtjceU8zdk77+xyrjS+wbxkx6rxBRyX3Eu5i6TbffpjNYAclqYGt6GYGvpNfPFRgjjK4YYq4Drw0orjJ5nMYZLdODGLqJqA+9e750eNbqJ01tH5UAuwZDsO/aLz7Y6Ti4BErz7u/e/iNmTVnoO4EBsYXUtfUd8+QO0cXgm4l22MdAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKPYWdU1hwppo3C2JYCCTuRNRY4lMppSEDBeO3LaCm4=;
 b=UmCQ0cVXUsMosy7kOA3csB7Pkb1hHPg+DocuGbHul8aMqkFY6hwkkQB0yLAXRuIpUD5kOuNzYDZGCuhbZIaUEphwd2tVE4ielMGuTcipM7qoE+hriRa2y98kOHPYZX9Y5F6ImFirHYjOHeEFTesLl9bKYDqYUJZN+yw9Od5YWdJKgVZE3+9oHtvh38nx0VvsoA5yh4vszCHif0AW19xdofHMlJxiZ6y6xbYRQ7zayyHjWU5LwzFih2uzAIaWBhzwQyJ25dR+3TyCr+nihJK80m3y8cA5ifbkTdxGuwIHi5dHY6BhMCjO76sfKJFgYRKgiTth/ESwWu7NPKWfH4iHGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2853.namprd12.prod.outlook.com (2603:10b6:a03:13a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Tue, 16 Feb
 2021 21:28:03 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e16c:ea19:c2a6:d8b8]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e16c:ea19:c2a6:d8b8%5]) with mapi id 15.20.3846.041; Tue, 16 Feb 2021
 21:28:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Raed Salem <raeds@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Thread-Topic: linux-next: manual merge of the net-next tree with the net tree
Thread-Index: AQHXAzTep+bYXRmgMk2U9KE5hEZ5fqpbTswA
Date:   Tue, 16 Feb 2021 21:28:03 +0000
Message-ID: <ea45718f370427c1d0845d9b55e4fac6359bf1f2.camel@nvidia.com>
References: <20210215115231.2311310a@canb.auug.org.au>
In-Reply-To: <20210215115231.2311310a@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e9311a2-bd0c-4d1e-391b-08d8d2c1be1d
x-ms-traffictypediagnostic: BYAPR12MB2853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB285347DBEB1D9B38CB3A12B8B3879@BYAPR12MB2853.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EOyVn/NRExK1RvzZvGxXT1xVR9eKA3MbUMJLx7FVtmYvqYunYiIF7vO42V/b6ErZQQi3iosmwwU0X6TO7LBcZlyS8SDewfKt1U4MAZNJ/uJjtWV3vV8EWYMVfruivOZHEb2xxinboVabIHmRKmA1iILCt3K6C3UISJyIckP2DdKazrH9ZywL/9iLFW8IbKUHR2Z/02wT22NlkUZvRXSSsg0Q6Y08gARLGkfw+cqA7Y5yw6f4EW48ujrfwzxsOoRZziJV6hacNpF42XW9z8CNdMKpWVSYMJd0vwLh7U+3y9XJfQPqHqMMmzCFMNr8eCoSWswv/DU+X2F+pcqXerDXu89MfxpKALodVFjH0VE1q7KM64zSg5KvhJyqnwPx/P5Z+hGb5jdhmJc4DBuOHbIfhhyBK2jVLVkgYUfl9qui/8gtw1aiS48bG082BcGPQolsMJg1xGs4KheoPqs20F3y3c99fCyGx3YKk33x5dTOJWZlPIqQKb0SwBDNHgmOtruWHpNu/ujPNTWADUdw3qp4Ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(76116006)(6512007)(26005)(8676002)(66946007)(66446008)(64756008)(66556008)(186003)(5660300002)(107886003)(6506007)(2616005)(66476007)(86362001)(110136005)(316002)(8936002)(478600001)(36756003)(2906002)(71200400001)(54906003)(4326008)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?REZxL0xCY3ZwdThkTnEyZ1F1NXZYL3JIc0lYc1hNbk5jbWJxdWpDQ3d4R0Nr?=
 =?utf-8?B?SFNocUF0N3VBTTJldjcrdXJJaDR6ZjdJVm9QRFAyMXlnS2hwN1RBQ0YwNU11?=
 =?utf-8?B?SldKRGNiM3ZnbnJvWDhqdjJaamt0TDlwRjREZVZWL1NZdVE4VVlaZU9XZnF4?=
 =?utf-8?B?QmllM0ZyR2kwQTFCZEtJUXpad0h6QzVNWlpOekdIRlZ3N0c4V0hLZ2F1S3ZC?=
 =?utf-8?B?aE9Yekc5bk01eCtGRVcvTENpLzhuODhramVRVjdIM2NpRmgvQkF5MjJ5TXY4?=
 =?utf-8?B?NjZVdDZJMVdWcEFXWm1lVXFTRVdJLzVkNWxWakJrVGtwK2c1Yjc0c3JQSWpz?=
 =?utf-8?B?aW9yRnVUOFFNbk1ac3gxTHlHUFF5OGZDMkRvSnR3VmM1Zm5OcjJrcVp3MzRa?=
 =?utf-8?B?Mk0vVXFZWkV4d0VnR29MQmVmTnVzOXBiazBuZnRMTDhSa3ZFSGlPWmJNZDVJ?=
 =?utf-8?B?YnFSYTdtRVJnckFNT2hrWm9ReHlJeGtrNXFoaXF3QnhOaiswMEE2TC9QOWlm?=
 =?utf-8?B?Nk4wS2tXTHFheklSUGE0OGh4MkN3SHBWYjkxSWo5YTFOc2tXTWtuR0VHR3F2?=
 =?utf-8?B?U1ZxWHZBS0VDMXNObm5YUEJSMTR1bTVkRlp4T1FjVWNOZEVYeEhxNm03TmpU?=
 =?utf-8?B?MmRkcXJCT3NsMGRlaFVaY2N0N1ZKd1BUWWh6VnpvdnBxQUtvRHRwd0p6ZDVj?=
 =?utf-8?B?eTc3UG5XdFdoZnpKNmdVMWRsUjlma1VFTWp1RmRpYlBDaGtCdzdnSDRkcFJl?=
 =?utf-8?B?SFZuS3AvQjNBR3lPRERadldpWmhBMzZLRE50Q0xjQ0psR2tWc0tWeWs1SGxq?=
 =?utf-8?B?bzVZTUQ3OERPYTIzcmkzVHRsRjA5RDlPV1dkcitsOTJrWC9MOUwrZDZLdmwr?=
 =?utf-8?B?TkduOW9VZThQcnFyQjkwQ1NQN1F3cTlMSVB2T1VjcGR3dlMrNW9iVnlsUEFi?=
 =?utf-8?B?NWh6QncvamZVc3VXODc2V0pDYXVhenZhQXRvYzA4WjRXbjkxNCtlMVhoajY4?=
 =?utf-8?B?UGxpdHF0cDlqZk91Ukw0UlZZaXNraE4vTFhtVkxNc1ZONm81ajE2Y3o0L0pu?=
 =?utf-8?B?emhpeThpZ2VRdWF1eG9hbkdNOUpiWXI3VHpjMjJRYmhrYWh2RkFtdGwwSEhU?=
 =?utf-8?B?WEQraDdvVDVGRTFKd1hVMnlxUWJFRjBNWGVlZnhiU245VHNzeXZSYW1KRjNW?=
 =?utf-8?B?YVBEM1pvaldpenZoQ1pUU2VPUkdsSjVieG5ubkN0ekRwd2dyQ1IrYUJPV2lG?=
 =?utf-8?B?RmpzdUVNREpSNDloSExRTXB2Q2tFWG5VMy90VjJtYkE2MVJJQ2ZhMisvNC9Z?=
 =?utf-8?B?ZnV5WW1SbHUwU0RCem9RVk9CZUJpaTdLaFFqajdYUS9PenFxYkI2M0JjdzRx?=
 =?utf-8?B?eXF0a0JNMGFsNHBaUU1Kb3BjY3A1endBaSt4MGI0eE1hcjczaU1qZVZ5NVRZ?=
 =?utf-8?B?YjMzcTBJT1ZGSXdJNDJETmlsQThrd3RXWW9hTzhyUDdXaDc3RXY1dmUvQWs2?=
 =?utf-8?B?MEpxTGRVayt0VzRjUHg3aWpab3U4T3BqeWdIS0xCdnlrNlE0VVA4VnBCNjZj?=
 =?utf-8?B?VkR5ejUxUEhJWHdVc2M0bkpESitaSlZpeXdyZ3kybkhoMDhNNlFpOW5TTE1J?=
 =?utf-8?B?MW5BUm0va1VEOVlaSFJhVllrdWl0YlNtSWY3TmFIR1pWY2Y5L2FVZ1g1NE91?=
 =?utf-8?B?U1VveTVBdjNQb01uVmg5c0s0b0ltNGRLVHFsSVBDTlRhUm1xaTl3aDFqOTRw?=
 =?utf-8?Q?Giy4RtLM2lQ8dOSSUxD6DESlOVpIlQK89zmLZoZ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FDC5E6619BCAF49ACC5C6B069A0C605@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e9311a2-bd0c-4d1e-391b-08d8d2c1be1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 21:28:03.1738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PYAGrBzCRiUlaqpoYUVWLSr/cS1lecODy2hJX94o6z0d6tIHqHplL5S+Os3DVUIdc5fO6fsQSuEEZWLAP5KOgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2853
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613510892; bh=bKPYWdU1hwppo3C2JYCCTuRNRY4lMppSEDBeO3LaCm4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:x-header:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=HQxiRKlvAdBOsfhht62e4B8iu03Aiq8eDllH2hXFPF9P3h1Bg2+3IRA22Q9q/LWWx
         OIN2UJkBZSwo4v5r7d1yIrCpJdtfm8i6OJMHsFhbFUDDMNH+Z4bLRVRUHpJ2cySMYK
         kzxoDNiaPeiMWJuIVKgRHcyqRg1hauYctMxdxpJG/TkomOfMV1dg8aL7Wze85LJ9kl
         cjN20D3fyjBdUoMMq0/9ROtHQ79tcKGzbbbCwRaNgzc7R4oArNLEyDxR9ve/Zedz3i
         JeCK52uIW153orj/bbOziOxcRA8RUuK7ubQk6vbHLCrTZfuT7rWmI6XFlZ8rxjC/PI
         ag/tuvop17Slw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAyLTE1IGF0IDExOjUyICsxMTAwLCBTdGVwaGVuIFJvdGh3ZWxsIHdyb3Rl
Og0KPiBIaSBhbGwsDQo+IA0KPiBUb2RheSdzIGxpbnV4LW5leHQgbWVyZ2Ugb2YgdGhlIG5ldC1u
ZXh0IHRyZWUgZ290IGNvbmZsaWN0cyBpbjoNCj4gDQo+IMKgIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4gwqAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMNCj4gDQo+IGJldHdlZW4gY29tbWl0Og0KPiANCj4g
wqAgZTQ0ODRkOWRmNTAwICgibmV0L21seDVlOiBFbmFibGUgc3RyaWRpbmcgUlEgZm9yIENvbm5l
Y3QtWCBJUHNlYw0KPiBjYXBhYmxlIGRldmljZXMiKQ0KPiANCj4gZnJvbSB0aGUgbmV0IHRyZWUg
YW5kIGNvbW1pdHM6DQo+IA0KPiDCoCAyMjQxNjlkMmEzMmIgKCJuZXQvbWx4NWU6IElQc2VjLCBS
ZW1vdmUgdW5uZWNlc3NhcnkgY29uZmlnIGZsYWcNCj4gdXNhZ2UiKQ0KPiDCoCA3MDAzOGI3M2U0
MGUgKCJuZXQvbWx4NWU6IEFkZCBsaXN0ZW5lciB0byB0cmFwIGV2ZW50IikNCj4gwqAgMjE0YmFm
MjI4NzBjICgibmV0L21seDVlOiBTdXBwb3J0IEhUQiBvZmZsb2FkIikNCj4gDQo+IGZyb20gdGhl
IG5ldC1uZXh0IHRyZWUuDQo+IA0KPiBJIGZpeGVkIGl0IHVwIChzZWUgYmVsb3cpIGFuZCBjYW4g
Y2FycnkgdGhlIGZpeCBhcyBuZWNlc3NhcnkuIFRoaXMNCj4gaXMgbm93IGZpeGVkIGFzIGZhciBh
cyBsaW51eC1uZXh0IGlzIGNvbmNlcm5lZCwgYnV0IGFueSBub24gdHJpdmlhbA0KPiBjb25mbGlj
dHMgc2hvdWxkIGJlIG1lbnRpb25lZCB0byB5b3VyIHVwc3RyZWFtIG1haW50YWluZXIgd2hlbiB5
b3VyDQo+IHRyZWUNCj4gaXMgc3VibWl0dGVkIGZvciBtZXJnaW5nLsKgIFlvdSBtYXkgYWxzbyB3
YW50IHRvIGNvbnNpZGVyIGNvb3BlcmF0aW5nDQo+IHdpdGggdGhlIG1haW50YWluZXIgb2YgdGhl
IGNvbmZsaWN0aW5nIHRyZWUgdG8gbWluaW1pc2UgYW55DQo+IHBhcnRpY3VsYXJseQ0KPiBjb21w
bGV4IGNvbmZsaWN0cy4NCj4gDQoNClJlc29sdXRpb24gbG9va3MgY29ycmVjdC4NCg0KVGhhbmtz
LA0KU2FlZWQuDQo=
