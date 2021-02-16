Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15CE31D236
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhBPVit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:38:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13936 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhBPVid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:38:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602c3b310000>; Tue, 16 Feb 2021 13:37:53 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 21:37:53 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 16 Feb 2021 21:37:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuvbnIAM4fm+JnUd10W3SzgARURFujgo9fRIsj/r7eXp40ceLRzqZzvtZ/7ra4x72s2mggSZb4ZxSqr/ULgkskFQGrVnT1bm/KjOeUxTYmHdnQWZ/GE3hmuXQpg+bOcpEKbVyiqNimZZVAW/j4eXiL3sDczScO2ZIKK4RfCak6rtm9ICOh7Cj2oCoU3RdT8ft9L5G7QvATY4Kh6UakO7IvdDc3naDwCyL15S5SfSbnOEm0Edr6u1Mdv9OB0Ogg9T87D0Lz+czfwwYONsrNoYo/taM4pZvkEj141jrmzgik46rXTQ3okJGAt9nap0BT62Qhq5c5Tng5Lx1+5eIzcnNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7ga1FzV7OSneqNv7CQth3HfuFpm5rzZrju/F8wJOrk=;
 b=WnE44zR77E7oJnIxk0tweQZZaxYcrY6934a+lRHj/TzKsTxdi8yY/f5jDUrH3vUwrA9pBGJ3e9lzjX0HLHIGqW9RNn6N9k/F8hgTm1K6Rv87AAumgUXg4ayaAayN8CSxE6D6aY99AZA6TwoqNaIPv3BAsbLwqLR2VqvleusQe9p2eYTOr2zbaJLpBN8QCRmRqds+UumoH/tkOPztUxPoexZUCCeBP7Y14G06ipJU0QtWPOunGSto0jpjiQPu+K3a6AynEsqsUtvk4elWyLsCR9qQYuGqlZHLck+mbRQp72AqgJj/A4khUKi/oGYfLuNZo+VsxWFQlWaC3EQoFs1K5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3591.namprd12.prod.outlook.com (2603:10b6:a03:dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.36; Tue, 16 Feb
 2021 21:37:51 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e16c:ea19:c2a6:d8b8]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e16c:ea19:c2a6:d8b8%5]) with mapi id 15.20.3846.041; Tue, 16 Feb 2021
 21:37:51 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        Ariel Levkovich <lariel@nvidia.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Roi Dayan" <roid@nvidia.com>, Ariel Levkovich <lariel@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH 1/2 net-next] net/mlx5e: TC: Fix IS_ERR() vs NULL checks
Thread-Topic: [PATCH 1/2 net-next] net/mlx5e: TC: Fix IS_ERR() vs NULL checks
Thread-Index: AQHWlb63UbuuxkNhPkyNqYVpmNKuaal+X44AgNtesYCAAm42AA==
Date:   Tue, 16 Feb 2021 21:37:51 +0000
Message-ID: <90552f255570173e43948c058185c6c60c2fd855.camel@nvidia.com>
References: <20200928174153.GA446008@mwanda>
         <3F057952-3C88-452F-BFC5-4DC2B87FAD67@nvidia.com>
         <20210215083050.GA2222@kadam>
In-Reply-To: <20210215083050.GA2222@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d244ef4-ddd7-4bc4-107f-08d8d2c31cb7
x-ms-traffictypediagnostic: BYAPR12MB3591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3591D97D9B5B8A53512ECD90B3879@BYAPR12MB3591.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n1svmO3tQJciMWTtNLhDNg1WLbXYFXx0aiFMUzT62BDkOD+f4rlWV99pM6EXn3gSXDR25pyBJu6AimjSunT6rC87e3TvTIFmH4adpRRKg1wg8zjAceu5pQVdTBpULUspJRMvbYqUMVkgNgQLc+HFLDojTwphKMt06XNnch8gusXKq9fsian5375qiMWqO8uWIsA5cF9FlfJqXo+A10CeVcAXYeZ5KNKLCOuZOrUpRJtuzuJ3mPGRwqUHJR1ZEnXvhpOTcsFU2t1j3dT4Ym2bTBFJ6AEnJa/1Zs9CWUznqbzocZ/aeSV6efC+3wPyrVvXUowb7B6guaG9LW7JWfXkEeM5LRev7IEAqyynx2UMPBdUjfwyRRJkoblkTddCYkAT4GBUjD60bvjNdVWM6lPxvsFYQ/KRka7KSzsZNJSZFRIAGpavMuiAKq2BWvTAW2qk3dJ7inxk9NSOfQYss4n0vPDaEdn/OW+AW+2XXGvek6DuPBC9s9dNnUia7iSw8zBe++Dtu0GTL9kJpxm7ezpt4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(2616005)(86362001)(71200400001)(478600001)(53546011)(8936002)(316002)(6506007)(36756003)(2906002)(83380400001)(4326008)(26005)(91956017)(76116006)(8676002)(6636002)(54906003)(110136005)(6512007)(186003)(66556008)(64756008)(66446008)(6486002)(66476007)(66946007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UlRvR0tUNkxNTUQ2Q1RBWi9NSWFhZ3VIOEhraVdQMW1tNjVWVEFVZXBZbU5v?=
 =?utf-8?B?Y2p3a3l0UkRiMDhibTV3UE5Ndyt0QlFnQW53L1lKbnljcExOdzRwZWcvdllV?=
 =?utf-8?B?SFkrK2oyTVdxa2xrN2ZiS0NQRm41c2szVE1xRFlpMVJidlpRbFI4UU1nRGJF?=
 =?utf-8?B?cVJDTHpTamp5aGdWbHZsV2hwRmpNNW01WER0SkdpS2hLM1o5bWpMNDlDZWJP?=
 =?utf-8?B?RkxmT2x2dHlvZ3o0MlVaRXpFckFma2NMamVVeEhOemIyZURZWHRhUzk3dGJY?=
 =?utf-8?B?dG1ZU0IzR1JSV1MzYnpqc0lMbkNBMFRsYlhKZHRlMzd3RjhRWUJzTklNa2JD?=
 =?utf-8?B?RWIwS2IvRnZtK2JxcTdOdEJhZmV4Ymw3RE5zSmJKWUxRTEFGbTlDTGUrajd2?=
 =?utf-8?B?c2hBdHQ5M01KWU1XMHBCem1ocDk4ZjBEdmJWUUpXQ3ZtQmtNVGRpbUxIU1Uy?=
 =?utf-8?B?bkxMejhHMER6M0JQVXVkOW1FOW5HakhyajZoclhtZUZCZkJaYmVDL2pzL1RC?=
 =?utf-8?B?N1RtNGJWOHlHb2N3d1lEMWgrZ2V4WnZNelUxZFVqUGlkL29pNFpwYzBzUVF5?=
 =?utf-8?B?ZWhvNEtpeE5sNStGU1dEaW43NzAvS2VFTk40V0FSN08wVzZLSlErT1pUMjFZ?=
 =?utf-8?B?NWhrekhRMWI4bldVZkRSK0k0dUtwUU5lYyt5blRIZnBRZmVxNWhSRkN2MkU5?=
 =?utf-8?B?SDlEcjhNWEZIemp5REM3UlFQejFEMUc0TUsxMmZTbk5sOFZSaEpTVzFwVlVj?=
 =?utf-8?B?MmhBSUt3T3AvVGdpUnlZRnlCbnFpVVVPSENjUmd0eWJSTEpjeE45Rzk4V2VD?=
 =?utf-8?B?V0Jud1d3UHdFeVNRRGVnUlE4dVBRU2xORlB0a1RScFA2WWtONUNTYTVoUGdI?=
 =?utf-8?B?OWMrZ05mbEdBcGhZM3VESHkveVd1a2ErUER4b0dFTnAzdkxWNGF5Q2xPQmlX?=
 =?utf-8?B?OHdUM0hta3dsdmtuRGlUWGhaNG0xcHFtaVpSNHNjdUdweWZTS2h5K21QTlZD?=
 =?utf-8?B?SHFGdjdvd2hLYjBtNXlSR1VHeVQxRDBaMHRKLzhuS0NZOVhnb2VKWVFUbnJF?=
 =?utf-8?B?QUVrdGZCK1BOWmRDdlljTExCTkNNRCtuc0lzYXJoQVQ0MGZyT0h1RWdXMWlj?=
 =?utf-8?B?a1F6YzNmcWJyYmpIVEV0ajE1OFZicTlRVkY2RFl6SlZhZXlQQUYxQmhaWmp4?=
 =?utf-8?B?dmRDY2V6aE8vWHMzQ2dWdEZ4K0J2SlNhYVVaMHYrb29SVVgvTnVNS0o1b1BW?=
 =?utf-8?B?bW5YWm1pUHcwcCtjM3NzVFd0OENoNUpGY2F1WGVJeWpTL21JaGRIK1hLUFFM?=
 =?utf-8?B?RUhpRjlNcXUySGkyNHRHWUNRekZFYmdmMVdUQXdSSTBUL1Q0YnlHS2R3QmdL?=
 =?utf-8?B?TUpveVpIcTF4YjUrMlVHUXVFQXVOOS9Na3R0T01uMVB1UTNZaTZEbEZHaWFj?=
 =?utf-8?B?N3BxL0ZCd2RiOEZNLzM2WGlmUHF2cGk3RmRPYXRUbDJzeHVGRWR2cU9tVzBh?=
 =?utf-8?B?MVkxQlAxQXNwNFFtRFBUeTRqOVFjSkROSHFvdzR4dTNvWGpvTGpOcGVIY0pZ?=
 =?utf-8?B?clVld200NzZSZEVSbEU0N1hncGMyZnFiL1JVVUlUcy9NQnlFdWF0czg3V0Rq?=
 =?utf-8?B?UHNCQ2ZJY1RZNE5UcERaQ3JWdmRZdEUyT1JHSjM2WW5NMk0weHd5Nm5Iek5v?=
 =?utf-8?B?L2pUVzNGcmtDNzl4SEx0OVlOUzRObURPNExLOWRLNm1kcmMxWHIyK2ZSMVpr?=
 =?utf-8?Q?iiZm/up4yTEVh/6881hrE8EziTrhpe/qMhCxBne?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8F7CCD28FDAD54183C9F2FB69A4D717@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d244ef4-ddd7-4bc4-107f-08d8d2c31cb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 21:37:51.4373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6R1YJ1Jn9c+s/CE1YvX5mtEhc37tbpUM+JNrVBtd35u0UtCuRdWKORRBNvquhurTLEDCvGLnRAmuFRlZYZdjYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3591
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613511473; bh=h7ga1FzV7OSneqNv7CQth3HfuFpm5rzZrju/F8wJOrk=;
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
        b=OHbGK0mVQMvCxBzbg2ffyNKnkcODpgPmgUqr4nW9hStnW6uqMg4lBY/yB4kd/izBD
         PewFn30qTCaNNfaIm/OKaVxE2pK1ZvRyusSNAo7DkFAFOo9GEJOejdeHIPPo86Y/3t
         fHbhgbxmJkZo3ZSLAOndRYnxx3bElerHntDbQLMUnbMmAN1yR+AcfKHKHvJu4tL7tn
         QMkss0W6DGp+X171ju6f0VrAbqHFejwyeTYhTg7X872ZAM+PyJiyRdAu3JHjK8D8GR
         9sCdaF9gvyrNV2mvlfGi/71fjKMj8iGRL9xND5bztfrILSHDOPFanqZOPl1HUXXBgi
         PPQYtoGO69ivA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAyLTE1IGF0IDExOjMwICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBPbiBNb24sIFNlcCAyOCwgMjAyMCBhdCAwNjozMTowNFBNICswMDAwLCBBcmllbCBMZXZrb3Zp
Y2ggd3JvdGU6DQo+ID4gT24gU2VwIDI4LCAyMDIwLCBhdCAxMzo0MiwgRGFuIENhcnBlbnRlciA8
ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPg0KPiA+IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiDvu79U
aGUgbWx4NV90Y19jdF9pbml0KCkgZnVuY3Rpb24gZG9lc24ndCByZXR1cm4gZXJyb3IgcG9pbnRl
cnMgaXQNCj4gPiA+IHJldHVybnMNCj4gPiA+IE5VTEwuwqAgQWxzbyB3ZSBuZWVkIHRvIHNldCB0
aGUgZXJyb3IgY29kZXMgb24gdGhpcyBwYXRoLg0KPiA+ID4gDQo+ID4gPiBGaXhlczogYWVkZDEz
M2QxN2JjICgibmV0L21seDVlOiBTdXBwb3J0IENUIG9mZmxvYWQgZm9yIHRjIG5pYw0KPiA+ID4g
Zmxvd3MiKQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRl
ckBvcmFjbGUuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fdGMuYyB8IDggKysrKysrLS0NCj4gPiA+IDEgZmlsZSBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPiA+
ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPiA+
ID4gaW5kZXggMTA0YjFjMzM5ZGUwLi40MzhmYmNmNDc4ZDEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPiA+ID4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gPiA+
IEBAIC01MjI0LDggKzUyMjQsMTAgQEAgaW50IG1seDVlX3RjX25pY19pbml0KHN0cnVjdCBtbHg1
ZV9wcml2DQo+ID4gPiAqcHJpdikNCj4gPiA+IA0KPiA+ID4gwqDCoCB0Yy0+Y3QgPSBtbHg1X3Rj
X2N0X2luaXQocHJpdiwgdGMtPmNoYWlucywgJnByaXYtDQo+ID4gPiA+ZnMudGMubW9kX2hkciwN
Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBNTFg1X0ZMT1dfTkFNRVNQQUNF
X0tFUk5FTCk7DQo+ID4gPiAtwqDCoMKgIGlmIChJU19FUlIodGMtPmN0KSkNCj4gPiA+ICvCoMKg
wqAgaWYgKCF0Yy0+Y3QpIHsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCBlcnIgPSAtRU5PTUVNOw0K
PiA+ID4gwqDCoMKgwqDCoMKgIGdvdG8gZXJyX2N0Ow0KPiA+ID4gK8KgwqDCoCB9DQo+ID4gDQo+
ID4gSGkgRGFuLA0KPiA+IFRoYXQgd2FzIGltcGxlbWVudCBsaWtlIHRoYXQgb24gcHVycG9zZS4g
SWYgbWx4NV90Y19pbml0X2N0IHJldHVybnMNCj4gPiBOVUxMIGl0IG1lYW5zIHRoZSBkZXZpY2Ug
ZG9lc27igJl0IHN1cHBvcnQgQ1Qgb2ZmbG9hZCB3aGljaCBjYW4NCj4gPiBoYXBwZW4gd2l0aCBv
bGRlciBkZXZpY2VzIG9yIG9sZCBGVyBvbiB0aGUgZGV2aWNlcy4NCj4gPiBIb3dldmVyLCBpbiB0
aGlzIGNhc2Ugd2Ugd2FudCB0byBjb250aW51ZSB3aXRoIHRoZSByZXN0IG9mIHRoZSBUYw0KPiA+
IGluaXRpYWxpemF0aW9uIGJlY2F1c2Ugd2UgY2FuIHN0aWxsIHN1cHBvcnQgb3RoZXIgVEMgb2Zm
bG9hZHMuIE5vDQo+ID4gbmVlZCB0byBmYWlsIHRoZSBlbnRpcmUgVEMgaW5pdCBpbiB0aGlzIGNh
c2UuIE9ubHkgaWYNCj4gPiBtbHg1X3RjX2luaXRfY3QgcmV0dXJuIGVycl9wdHIgdGhhdCBtZWFu
cyB0aGUgdGMgaW5pdCBmYWlsZWQgbm90DQo+ID4gYmVjYXVzZSBvZiBsYWNrIG9mIHN1cHBvcnQg
YnV0IGR1ZSB0byBhIHJlYWwgZXJyb3IgYW5kIG9ubHkgdGhlbiB3ZQ0KPiA+IHdhbnQgdG8gZmFp
bCB0aGUgcmVzdCBvZiB0aGUgdGMgaW5pdC4NCj4gPiANCj4gPiBZb3VyIGNoYW5nZSB3aWxsIGJy
ZWFrIGNvbXBhdGliaWxpdHkgZm9yIGRldmljZXMvRlcgdmVyc2lvbnMgdGhhdA0KPiA+IGRvbuKA
mXQgaGF2ZSBDVCBvZmZsb2FkIHN1cHBvcnQuDQo+ID4gDQo+IA0KPiBXaGVuIHdlIGhhdmUgYSBm
dW5jdGlvbiBsaWtlIHRoaXMgd2hpY2ggaXMgb3B0aW9uYWwgdGhlbiByZXR1cm5pbmcNCj4gTlVM
TA0KPiBpcyBhIHNwZWNpYWwga2luZCBvZiBzdWNjZXNzIGFzIHlvdSBzYXkuwqAgUmV0dXJuaW5n
IE5VTEwgc2hvdWxkIG5vdA0KPiBnZW5lcmF0ZSBhIHdhcm5pbmcgbWVzc2FnZS7CoCBBdCB0aGUg
c2FtZSB0aW1lLCBpZiB0aGUgdXNlciBlbmFibGVzDQo+IHRoZQ0KPiBvcHRpb24gYW5kIHRoZSBj
b2RlIGZhaWxzIGJlY2F1c2Ugd2UgYXJlIGxvdyBvbiBtZW1vcnkgdGhlbiByZXR1cm5pbmcNCj4g
YW4NCj4gZXJyb3IgcG9pbnRlciBpcyB0aGUgY29ycmVjdCBiZWhhdmlvci7CoCBKdXN0IGJlY2F1
c2UgdGhlIGZlYXR1cmUgaXMNCj4gb3B0aW9uYWwgZG9lcyBub3QgbWVhbiB3ZSBzaG91bGQgaWdu
b3JlIHdoYXQgdGhlIHVzZXIgdG9sZCB1cyB0byBkby4NCj4gDQo+IFRoaXMgY29kZSBuZXZlciBy
ZXR1cm5zIGVycm9yIHBvaW50ZXJzLsKgIEl0IGFsd2F5cyByZXR1cm5zDQo+IE5VTEwvc3VjY2Vz
cw0KPiB3aGVuIGFuIGFsbG9jYXRpb24gZmFpbHMuwqAgVGhhdCB0cmlnZ2VycyB0aGUgZmlyc3Qg
c3RhdGljIGNoZWNrZXINCj4gd2FybmluZyBmcm9tIGxhc3QgeWVhci7CoCBOb3cgU21hdGNoIGlz
IGNvbXBsYWluaW5nIGFib3V0IGEgbmV3IHN0YXRpYw0KPiBjaGVja2VyIHdhcm5pbmc6DQo+IA0K
PiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYzo0NzU0DQo+
IG1seDVlX3RjX2Vzd19pbml0KCkgd2FybjogbWlzc2luZyBlcnJvciBjb2RlIGhlcmU/ICdJU19F
UlIoKScgZmFpbGVkLg0KPiAnZXJyJyA9ICcwJw0KPiANCj4gwqAgNDcwOMKgIGludCBtbHg1ZV90
Y19lc3dfaW5pdChzdHJ1Y3Qgcmhhc2h0YWJsZSAqdGNfaHQpDQo+IMKgIDQ3MDnCoCB7DQo+IMKg
IDQ3MTDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc2l6ZV90IHN6X2VuY19vcHRzID0gc2l6ZW9m
KHN0cnVjdA0KPiB0dW5uZWxfbWF0Y2hfZW5jX29wdHMpOw0KPiDCoCA0NzExwqDCoMKgwqDCoMKg
wqDCoMKgIHN0cnVjdCBtbHg1X3JlcF91cGxpbmtfcHJpdiAqdXBsaW5rX3ByaXY7DQo+IMKgIDQ3
MTLCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IG1seDVlX3JlcF9wcml2ICpycHJpdjsNCj4gwqAg
NDcxM8KgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgbWFwcGluZ19jdHggKm1hcHBpbmc7DQo+IMKg
IDQ3MTTCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3Ow0KPiDCoCA0
NzE1wqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2Ow0KPiDCoCA0NzE2
wqDCoMKgwqDCoMKgwqDCoMKgIGludCBlcnIgPSAwOw0KPiDCoCA0NzE3wqAgDQo+IMKgIDQ3MTjC
oMKgwqDCoMKgwqDCoMKgwqAgdXBsaW5rX3ByaXYgPSBjb250YWluZXJfb2YodGNfaHQsIHN0cnVj
dA0KPiBtbHg1X3JlcF91cGxpbmtfcHJpdiwgdGNfaHQpOw0KPiDCoCA0NzE5wqDCoMKgwqDCoMKg
wqDCoMKgIHJwcml2ID0gY29udGFpbmVyX29mKHVwbGlua19wcml2LCBzdHJ1Y3QNCj4gbWx4NWVf
cmVwX3ByaXYsIHVwbGlua19wcml2KTsNCj4gwqAgNDcyMMKgwqDCoMKgwqDCoMKgwqDCoCBwcml2
ID0gbmV0ZGV2X3ByaXYocnByaXYtPm5ldGRldik7DQo+IMKgIDQ3MjHCoMKgwqDCoMKgwqDCoMKg
wqAgZXN3ID0gcHJpdi0+bWRldi0+cHJpdi5lc3dpdGNoOw0KPiDCoCA0NzIywqAgDQo+IMKgIDQ3
MjPCoMKgwqDCoMKgwqDCoMKgwqAgdXBsaW5rX3ByaXYtPmN0X3ByaXYgPQ0KPiBtbHg1X3RjX2N0
X2luaXQobmV0ZGV2X3ByaXYocHJpdi0+bmV0ZGV2KSwNCj4gwqAgNDcyNMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoA0KPiBlc3dfY2hhaW5zKGVzdyksDQo+IMKgIDQ3MjXC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJmVzdy0NCj4gPm9mZmxvYWRz
Lm1vZF9oZHIsDQo+IMKgIDQ3MjbCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqANCj4gTUxYNV9GTE9XX05BTUVTUEFDRV9GREIpOw0KPiDCoCA0NzI3wqDCoMKgwqDCoMKgwqDC
oMKgIGlmIChJU19FUlIodXBsaW5rX3ByaXYtPmN0X3ByaXYpKQ0KPiDCoCA0NzI4wqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGVycl9jdDsNCj4gDQoNClRoZSBkcml2ZXIg
aXMgZGVzaWduZWQgdG8gdG9sZXJhdGVkIGZhaWx1cmUgaW4gbWx4NV90Y19jdF9pbml0IGFuZCBp
cw0Kc3VwcG9zZWQgdG8gY29udGludWUgaGVyZSBhbmQgbm90IGFib3J0IHdpdGggcmV0dXJuIDAu
Lg0KDQpzbyBlaXRoZXIgcmV0dXJuIHByb3BlciBlcnJubyBvciBjb250aW51ZSBpbml0aWFsaXpp
bmcsIHRoZSBjb2RlDQpjdXJyZW50bHkgaGFzIGEgYnVnLiANCg0KVGhhbmtzIERhbiBmb3IgcG9p
bnRpbmcgdGhhdCBvdXQuDQoNCj4gSWYgbWx4NV90Y19jdF9pbml0KCkgZmFpbHMsIHdoaWNoIGl0
IHNob3VsZCBkbyBpZiBrbWFsbG9jKCkgZmFpbHMgYnV0DQo+IGN1cnJlbnRseSBpdCBkb2VzIG5v
dCwgdGhlbiB0aGUgZXJyb3Igc2hvdWxkIGJlIHByb3BhZ2F0ZWQgYWxsIHRoZQ0KPiB3YXkNCj4g
YmFjay7CoCBTbyB0aGlzIGNvZGUgc2hvdWxkIHByZXNlcnZlIHRoZSBlcnJvciBjb2RlIGluc3Rl
YWQgb2YNCj4gcmV0dXJuaW5nDQo+IHN1Y2Nlc3MuDQo+IA0KPiDCoCA0NzI5wqAgDQo+IMKgIDQ3
MzDCoMKgwqDCoMKgwqDCoMKgwqAgbWFwcGluZyA9IG1hcHBpbmdfY3JlYXRlKHNpemVvZihzdHJ1
Y3QNCj4gdHVubmVsX21hdGNoX2tleSksDQo+IMKgIDQ3MzHCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBUVU5ORUxfSU5G
T19CSVRTX01BU0ssDQo+IHRydWUpOw0KPiANCj4gcmVnYXJkcywNCj4gZGFuIGNhcnBlbnRlcg0K
PiANCg0K
