Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4ECC41E1FF
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 21:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346636AbhI3TII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 15:08:08 -0400
Received: from mail-bn8nam08on2052.outbound.protection.outlook.com ([40.107.100.52]:9952
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346668AbhI3TIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 15:08:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJD4JGXtg8qytL7NRn/eL8bqmb9gfFrgyiZrGQt5hmBKrlxU1W2Gkq45YIBh9CHDEa99WP+MZic9DP+7VWwUq/jmKcIiL12RQLCbQ0vqmUjkHRO7oXxDrbjYBnvpIri1czTXm3ogVgdJ//E/hfRjsievgbb4GbyXiSzmE3GEl//HgxMIndjfgqHYuHkwuqUMmlYNA8YCNkxYzAzo0HOeK/cM+4ybSKBGNUiYVowoJ84DfH16lpysXMh967bjEvpDNe9DBULG4cXFIDBXvqh/mA0wN3m+UHrGsNTVRX2wwkO1KsDQdjpxuj0oTSRpQPvRUvgj5ZcBbxqSpKTa9k+jWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=v6s1tyJ94ACF9axSJ8wW64ZwuSgkNB4KS+0ggY4jcAM=;
 b=Srpzb+vLi4m1RDbXMVv9O84erBu2fW2lmjbc4HWGiwXgR58IhNxtE0poV0irH/fJwjQ22jmwK9629FGj+npcR9Lfz3mtWQR2ok3JDglwRHUDsFYfeynfojOh5TMVb9hwigHiB2YrncWEFMqo2voIacEJl/Zb8oExoAizJzQ3mWFlBNhx75rGXhWvg/ehtC08gTqkAv8CM/kwmC90o8U6F0A19nI61iFJXCQgMiiuGim/djVwDBzqBMjuYs3WY3ITJH1MYaHQViSoj10d1gAi/QVxLi3dmu5yq9vsVypmLq7aO0qRbNzceLQjuS9XaOsaxiY4UQcei4LbiKekWyk45Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6s1tyJ94ACF9axSJ8wW64ZwuSgkNB4KS+0ggY4jcAM=;
 b=adqXwydLl8ClMAVbCLHzybczKj8pdgo0++RkqCUOFbvCr1nI3eDISy3TLIfsv7hkfkYT77me39tT6NmsQn4gtvHEm0LlvqukonZ5ySdxnU+9FZgQZTXCDd4H9zkNF3Ym5KGkN3mrwohofhLza6BYqKX+P7O0fv6i3SgeAOC13iUXDX3NJyxvksiEpFRvuXyS05EbpaHKSgpFKS/lf/5wRUHUyZEul7Ui0Zb12bLjx5SOY+Coq4y+lWtgdKo+P6hWBXAugzPG0XDa/pzs82jKlUU7GgSHK5aivTm10IravLjZSGoD/49WL8lIXH+s6yN7sdPMlKd0Ovsy5IsnwerxFw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2661.namprd12.prod.outlook.com (2603:10b6:a03:67::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 30 Sep
 2021 19:06:21 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%6]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 19:06:21 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][net-next] net/mlx5: Use kvcalloc() instead of kvzalloc()
Thread-Topic: [PATCH][net-next] net/mlx5: Use kvcalloc() instead of kvzalloc()
Thread-Index: AQHXtLRKZdHsV+rBWEeKlbqw6cPqQqu88xgA
Date:   Thu, 30 Sep 2021 19:06:20 +0000
Message-ID: <d5861e2479d634456c633239c9c6eb9d836e5514.camel@nvidia.com>
References: <20210928220447.GA276861@embeddedor>
In-Reply-To: <20210928220447.GA276861@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83aa8a61-fca6-409d-7e9d-08d9844563c9
x-ms-traffictypediagnostic: BYAPR12MB2661:
x-microsoft-antispam-prvs: <BYAPR12MB26612EECB4A807CBAD2ED511B3AA9@BYAPR12MB2661.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:473;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I7kNx7X7P507E02F8M+H8VXuY54cG1e3405u3XWK2Ub1q3N0YYHOWXkW5wbgo348TcTFaYfiOFZX1/Sm625GbVAd0sPBk0eKmonYDeINqup1dGemSwlQsKHmUI4FPnGjgyAgYO+9VzFLEqkByMWcmKDvAqKRx80R6FXhr8tl2z2VgLDoZfYcpTtP6gPzh+HS4Y9vh8Tqmfb+rOUJBwtEngv7lE+pQKnXCYknJV9aWXu0rt1lZBJ/wCkeUAstQpolNwj/5HpxZ0WnK1bdt3MYd4vV6v9+ysKhcXsXL+7ftkGFcPCUkPADhj7DDu3Toxi3zeFlAUMgb1hwuOegrAG/RhoZ3YxJwU5Pup7p/00amebMFPrgfLHJVZ9ND4+BM8382iWidDu15fhyBmhpL1CGSjY1T/an/DQa7BAP9DmnC2qLf4Iks7nKuWLVMxtvXJxMf3Ts/r4v57Wlq0Aym6ObGtOS+e2f/yZLGChxxHojEh1ESeCNkPyBzxE5k4r2PSgQgIC1MgecMjHMVqOvsIO3k539SqPof+izLVdcVh/MyPUQZnknweiITwvHInGPKCQ7NPyORGLS9iKUT6Z0IEn+fvWrNn5hwsbZsnFygTdiCHW2HCJurUh0eLe06xqZSLG+ZiK8owR8h6p0V58gsjkLIQLx/D4gn/hPXGl8f76mbQ3LWG0qozC2XfWCqVaQfh7yJtkZP3gjmlU79CkHpTrANSoWhiZwlgKuWLyAPYi9uCHQch8Ie1TlED45XXjiWlTD1UiCHv8lytnwalnLQhMF3uXAk2GH7Z8V42ZaVpc97q4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(122000001)(66446008)(66556008)(64756008)(66476007)(66946007)(6512007)(4326008)(6506007)(186003)(71200400001)(508600001)(966005)(38100700002)(26005)(38070700005)(316002)(558084003)(54906003)(110136005)(36756003)(86362001)(5660300002)(6486002)(8676002)(2616005)(2906002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cERSZWh5TmYrYzNjUGFiWTQ2V3NpaU9Id2xqM3V3ZFZpK3NBeW4vVHNVc1kw?=
 =?utf-8?B?eDRGdGFuV1FzTE5Vb0F1dThUVFF6MjJWazFCVW5VQWlMTDJMZGJDTVRkQ0ZI?=
 =?utf-8?B?UVRVSFh0RUpySlA1dmJQTmhwbHl0QVg0T1pYRkxuZjRYcTF1dWwwcDdNU1M3?=
 =?utf-8?B?QUpKSzJGbkdyWkViMDZzTFFqZGFNU0UySXdDZ1dsUkx4Q2s2R0pZcElCS3ZB?=
 =?utf-8?B?Ky90azhvNWt3SXBudlAwbkFFaU5NMzJJKzI4MjhmaE9EVUdCaS9YZGVVemRQ?=
 =?utf-8?B?ay9NVDlQTFlEOWZ6VWREYUNmMkFmWWZvSzlHSFRwVktlTmo1WGVVd2FnQ2gx?=
 =?utf-8?B?ZXV3OEtXQ09zZ3dTKy9CcHM3Yjd2RHpNNk5rdHM3TmZqSjFKMmRNclc3MWY3?=
 =?utf-8?B?OWtwc0NRamFabWdEWm52M2REZ25yVTZnWFBwWGp0MEg1eVN6U2IwTERkeHpk?=
 =?utf-8?B?dDREWUwyYmZBRXZ1THRYc01yMlNUUFk1RFJmZkVKajlsMExuNEhIN0huOFFI?=
 =?utf-8?B?QVNrMlp5RW9zUlNRcG5WV1hKbXhDblV4TktKOEhFUGxlQ2RTVlVIM1NnVHhQ?=
 =?utf-8?B?OGsvMnhwMFJWak5kNnZ0M3N2c3RwMmhaT0liWnpocndVOGJGZGNieDZwdjFl?=
 =?utf-8?B?WHNFUUF4REU0TW0xY2F2NVdVVjVHR1o5THRWa3F5UExiY2t5NHBtUWlpOGxx?=
 =?utf-8?B?YnhVYWNmSjJUU1kzOUl5ajJaa3NlMktKQ1RseDRqKzVkMHpvTFJzKzA1UXpu?=
 =?utf-8?B?dVAzeEhjNDdnUGFNVERya1FiWVlTcDZoSS9JZHE0ckY3ODJqalEzM1lsdEZB?=
 =?utf-8?B?dGQ4eFZMNDBFNEhGUUpIcGpYZDY0TUhrbEg0QzFKeWlQRS83WmpQaDVwcno3?=
 =?utf-8?B?MlJSeWJIcitheXMxQzBCUEVQN0FsQWJoUUVDd0dEd05QcE5GMTQ3QTROcXBm?=
 =?utf-8?B?elBzYWxjTjZoSlZqMTN2THkrUndZTFhpbmRac01XTlB5MHYxT1ZValpPK1dV?=
 =?utf-8?B?dmVBN0J2Mysra2UrNmZ4RXgweTVvV2s0TlViZXlSSkJTM1pmNXFnYVE5MjdR?=
 =?utf-8?B?OW1pSExOUk1lNlpDTngwdThibkNSQ0tBWFhpckpzZUtvdlJpbmgyYlQ5TklR?=
 =?utf-8?B?a1VOSFJLWmpyYS9raGRUQmpuSXZhWmc4ckMrRGtYU3dZcmQydzE4Qk9obmVw?=
 =?utf-8?B?WFJhUWxhL2hLdUVtY1F4QUpsS0dxRFp1Nk1zVldVTDdoNFJUZFlSNlI5VGFB?=
 =?utf-8?B?djMvajhzd0c1YUlkeUVVVlFYOURBNnk1SmxlNTNESDlxS2hXcjVxaldnUGtB?=
 =?utf-8?B?VjFoaUVPQk5CN3hXTW1sRmpLQWM5bitQd3JKQjBEZXN4YjgxZ1NiMmdXbW8x?=
 =?utf-8?B?c2xVb2dvMU5wbXI2cGcwM3hNTy9KZ08vN0piOTRYaWpSVU9PTXl4V1RvZDF6?=
 =?utf-8?B?M2lpZjRpcjBjZmlJc3Q1amMvK1JsSVZNQWwwcDUxQ1NNSWQxZnRBN2Z0aGNo?=
 =?utf-8?B?dXRIZEUvcWZrNDBDb3o1NzBnNHR4ODJ6dXlHcFZLNHNVMUpidG5qdTZaQWwv?=
 =?utf-8?B?NDNZejBCdWpQVHpST0wrOFpOdnFiTmpBWnlHUlliK3NWVE94Vm53c20vak9G?=
 =?utf-8?B?R0p4aTY5b0ZrUmdtVkh3MXFlMXRFUENKbkJ5Rk5XL0pLeFRmWnYwVFVXbS82?=
 =?utf-8?B?M3d4YTIvV20vcGFpVVAyQjc2ZVh3azJhcWxuby95M2x5Z1lDSVZhYk9RWndu?=
 =?utf-8?B?MkJoRlZLN2lqbUs2TTQzb1U3ZEd0WGtnRElsM1FMUnhIVVJSZkxBNS9OQm5t?=
 =?utf-8?B?MTd5NDhvU1lLUnErb3ovUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <53468E1BCD3F4841952BE776B42E1C86@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83aa8a61-fca6-409d-7e9d-08d9844563c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 19:06:21.0140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XfJ30b3AhaqjmyOuiW2gO7h7Ffr77h/vPPoWZx5/zLiJ8DSznCDeBivrH0Fk1MTybl+csoz6zhaq8FbvVd6FxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2661
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA5LTI4IGF0IDE3OjA0IC0wNTAwLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdy
b3RlOg0KPiBVc2UgMi1mYWN0b3IgYXJndW1lbnQgZm9ybSBrdmNhbGxvYygpIGluc3RlYWQgb2Yg
a3Z6YWxsb2MoKS4NCj4gDQo+IExpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS9LU1BQL2xpbnV4L2lz
c3Vlcy8xNjINCj4gU2lnbmVkLW9mZi1ieTogR3VzdGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b2Fy
c0BrZXJuZWwub3JnPg0KPiANCg0KYXBwbGllZCB0byBuZXQtbmV4dC1tbHg1DQoNCg==
