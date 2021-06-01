Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4760F3978DD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 19:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhFARPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 13:15:50 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:47766 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231918AbhFARPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 13:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622567645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTQw1TVQ8Lg/6mLkaZs56I/u+lnvBBWOvf0oSn1Mv2Y=;
        b=JHXhsLMGA5Rg36M1TvonCHUehizA54dmzSGqscXgGh9IUY4idfJeqboGZI9ixRUsLHkPTt
        fdtO0w5E6g4zLdJgVc9efuEwm8xCxZEHNwBvtVx186dF78QMPMXkvRDNttpc4yTqPcIAHU
        gKa7a3lP5jwHBobH2mA1wr36XS5B39o=
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-DHX4qABcNYGIkw8DPnrung-1; Tue, 01 Jun 2021 13:14:03 -0400
X-MC-Unique: DHX4qABcNYGIkw8DPnrung-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB1519.namprd19.prod.outlook.com (2603:10b6:320:2e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 17:14:01 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::2d80:e649:6607:602]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::2d80:e649:6607:602%7]) with mapi id 15.20.4150.032; Tue, 1 Jun 2021
 17:14:01 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH] phy: maxlinear: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH] phy: maxlinear: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXVroHEbMjrtQ6106BPmeNcMQqZar/GY4AgAA1jQCAABEsgIAABUsA
Date:   Tue, 1 Jun 2021 17:14:01 +0000
Message-ID: <089adb48-c3f7-4c4e-808f-b303a0cd16d6@maxlinear.com>
References: <20210601074427.40990-1-lxu@maxlinear.com>
 <YLYrFDvGr7flA9rt@lunn.ch>
 <050c9cd2-ba6e-332d-d235-4fa9364b461b@maxlinear.com>
 <YLZmZ0pa4vULonsZ@lunn.ch>
In-Reply-To: <YLZmZ0pa4vULonsZ@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
x-originating-ip: [138.75.151.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14e24347-178f-4de1-2251-08d92520a684
x-ms-traffictypediagnostic: MWHPR19MB1519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB1519B7B126ABBB06B42E364CBD3E9@MWHPR19MB1519.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: s5ryqvmX50mTN9m5KuVEH7KEBdhk8k4fkGEaaUU27KGdmMWGuMtvfxryxmAv1mA1hs6G6JjZUMdfCIcBE6kARboM2OAruO2EGpa6rkQX2zwV7DzYP/qMBWuWY9PjoZ17rcc/oXsSTR9HU6AQeucW3wSeKLMjyakSuattOcGbPUbX6JPNiioLki5YEL2lIWBghYTdxGq7AOCveg8JlLLyXsIPbP9nht6BZHtTakRaXrdmJXoegJwCUvAAAdesMrxy4af83Hz7SusKA1nTzxN1l68KnoEa1D4damEwYNB65lc6BePT0Q8dnTsiDhfRXKfxt7Kol+3tTqnJep43eJnIapeAZhlopCJKwR1nC0iahX79+yfE3vXluw0GghvfLB9pK0I32lWu9pWycjXR0PK1WnS2cEq4zlixhkGSEHyuKGIqqTy5ZWlQorCR0USZ/s6Ai64Yl436pucEnsLXbQU4WV7MuGKMJKFpIK1UGWN2dlqpS/2b/3/cGY8bhBIe/1zoDUrt2KPpO4lEPFXPM7191tN6Vs0GM9W6qD/SNxtyIl8urYIKsoqg0V3Kv4itqN1dIzY1wLLmmy7eoJZ92L5Q+2XNs7fJPmGGGWEeG8UxvOIsYT41OCC7dsO3UiEl9V2eoqQj+1kHwp1bZJmxUeSAUvr78QOgtumD+mpvbm0gcuk0yFNOgSlpFYRgyBWqxllr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(366004)(396003)(136003)(346002)(8936002)(31686004)(66556008)(76116006)(36756003)(64756008)(91956017)(66946007)(71200400001)(53546011)(54906003)(4326008)(6506007)(6512007)(31696002)(83380400001)(316002)(5660300002)(6486002)(2616005)(107886003)(186003)(26005)(6916009)(86362001)(122000001)(38100700002)(2906002)(8676002)(66476007)(66446008)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?aHI4QlFLVER4QkV3SmFTaHo0T2ZNT3U1VkFNUFNnOGFVZ2UrcmhYZ2U5VDRS?=
 =?utf-8?B?cnYwOE54bkgwYlFyUzRCZDZHbmdOZjNGbDJZaUxOUjdPYloyeUsySnVZbHlN?=
 =?utf-8?B?Nk0xdXE4N2pDczFWL1o2enlrUzA4SllDcmJQQ0xGdUlSSUV2S0tIZWNmeEU3?=
 =?utf-8?B?OVNKRTJqdUxEc0pFdlBKeCtsb2RiMkIyTzg2QzJsSGxLTXQrNHFXYzQzS0E1?=
 =?utf-8?B?bGhYeTRUYjRJZDJLVlFjbGh0QkppOGlrN3p6UGZRRmdyWkVMRXhYU3JmeUNK?=
 =?utf-8?B?ZFZ6SnFWY3c0ZkxNTC80QVZJR1BUT1V6OXd6cmRoZlRYdEFxMnFNN0xDdmxB?=
 =?utf-8?B?U1ZYWVorZUFJaVhKUGM0M0ZzOGorcEFqZWw2ZnJkVFRUTGxsVEdRd0R2V2l4?=
 =?utf-8?B?OTVGTUtqTmkvaXNadjUrcm5VOFVFcmc3OHM3S1RYSmUrYTROWWdyWkovN0tF?=
 =?utf-8?B?ZzlLaGhZTjg5ZnpKcUxTa2tUMUVJM2VCVFZUS1o4RDd2bVUwTjB3dFpYNGs1?=
 =?utf-8?B?ODUvWkl0RUozTSs2WHJvYjJwZ1FkNldPQkxkM2pUc0tzUG8ybXhYMi85bTNX?=
 =?utf-8?B?aStjcW1wYzk0UnAwMDlwQ1NneFluU21lWWRycXJvU0dNVmw4ZUlmZEJqTFU3?=
 =?utf-8?B?R2RrMWE5WmhGOHJhWWR3NUdNb2dVSkYzUUNWdkVRbnFQWnhGcFBDOXdHTXd1?=
 =?utf-8?B?YTcxU21MekZsaHlkWE0rdDRMZHhFWVBva28xT2FDTzZ4N2EzcmZKMWNiRFJT?=
 =?utf-8?B?ZnJwcGk2Z3YxRC9PUktnWFN3ZFhjYk1COFlmeENsSFErbkJaVGlFWXBTZFhr?=
 =?utf-8?B?WU5iaUJIcFRCRHAwem1IbUhIcDR3V3pudWc4Z3VTcEZmNERqUnZtYlZqeU1w?=
 =?utf-8?B?dGFzRmFabzI1S3pIL3BWNVVPU1AvcmFpRFJ2eGNmUFNDUHQ3VHc4ZU9BQTZ4?=
 =?utf-8?B?b21vZXdLcnNDeVl0MjREUDhQeUxwL3BPeUNUSHFXM1lWdTRIZ09lbU1KZjFZ?=
 =?utf-8?B?eEROd3VpTHMvaFFwRWd2MytiREYwdUJlUG81eSt2QUZ2aG1RK0E2VHo1QXA3?=
 =?utf-8?B?aVh5NE54MTR2M2VUNm85UkhtSDJwaVpWOEQ2b2FUd2JCVnEwajZEbW1EaUEx?=
 =?utf-8?B?WktlNWlRRkNQRWp6Zi8xcnpkNmZkOG0zZENKWTlualdmeTdmR1ZnUlNJaldJ?=
 =?utf-8?B?aU5vbUx3SDQzUDNBMHA3elhOYjFSeVpRUG9yTURzOFBwWGtwQ2c4RDFEWXJR?=
 =?utf-8?B?b1g1RjRrR1p3VDUyS1RpeTloRXNBc1FVZVRmMEp3MXNEanQ3Z0hMUTVWQk1t?=
 =?utf-8?B?MXIrU2U1bFdhNUkyaGpMcnVJSmQ5UnpReitjeHNSUTRhNVYyWUVVeHE0d0Ru?=
 =?utf-8?B?dUg4a0dZYUdwaEZFbHYyMkdXY1hta2NLRm50YmtUQm5DK2FNcEFGY3JxVXNo?=
 =?utf-8?B?ZFFQVlhTTXE2MW5QY2k5QkYydFYzU0VoVDdyQmZQSUo3QW5ZeThwTW5DOGlV?=
 =?utf-8?B?eStCZjZ5N1RKN0k0ZDcwQVRONTdYUkluM0M4SFVUbnpjbHJzWExidWdSalpS?=
 =?utf-8?B?WUVzb3pHOVFmZWVFMUNPbTNjcVlsL3NObnNWT3dJRWg4YnRwc25hY2IzaGgx?=
 =?utf-8?B?ZnFmekZ2R25CTVdoVnV1ZlFIQ3ZYUW13UHdDWXNzdE5GQ2pqMHhFZFV0QW8w?=
 =?utf-8?B?blJJYUxpc25RdEIvMVRSU1YyQ0VqS1RpTWk0SmYzSFdGNFdUV1VpdkRVak00?=
 =?utf-8?Q?jJu/OECO+Zw1HmHvxRWDRBL8HnCdbXP018kI0pV?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e24347-178f-4de1-2251-08d92520a684
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 17:14:01.0435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cqSsqOEggIQbpYR7K5xBT71z/cyiN8WLKohp/DSqiHNf6GPmAkNnyXNsNQWvrzkUQM62JLPNLXhs6+SqVcjmaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB1519
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <2D0F44D54E0E6547B043AF86FFD183E3@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMi82LzIwMjEgMTI6NTUgYW0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBUaGlzIGVtYWlsIHdh
cyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+Pj4+ICsgICAgIGxpbmtt
b2RlX21vZF9iaXQoRVRIVE9PTF9MSU5LX01PREVfNTAwMGJhc2VUX0Z1bGxfQklULA0KPj4+PiAr
ICAgICAgICAgICAgICAgICAgICAgIHBoeWRldi0+c3VwcG9ydGVkLA0KPj4+PiArICAgICAgICAg
ICAgICAgICAgICAgIHJldCAmIE1ESU9fUE1BX05HX0VYVEFCTEVfNUdCVCk7DQo+Pj4+ICsNCj4+
PiBEb2VzIGdlbnBoeV9jNDVfcG1hX3JlYWRfYWJpbGl0aWVzKCkgZG8gdGhlIHdyb25nIHRoaW5n
IGhlcmU/IFdoYXQNCj4+PiBkb2VzIGl0IGdldCB3cm9uZz8NCj4+IFRoZSBwcm9ibGVtIGNvbWVz
IGZyb20gY29uZGl0aW9uICJwaHlkZXYtPmM0NV9pZHMubW1kc19wcmVzZW50ICYNCj4+IE1ESU9f
REVWU19BTiIuDQo+Pg0KPj4gT3VyIHByb2R1Y3Qgc3VwcG9ydHMgYm90aCBDMjIgYW5kIEM0NS4N
Cj4+DQo+PiBJbiB0aGUgcmVhbCBzeXN0ZW0sIHdlIGZvdW5kIEMyMiB3YXMgdXNlZCBieSBjdXN0
b21lcnMgKHdpdGggaW5kaXJlY3QNCj4+IGFjY2VzcyB0byBDNDUgcmVnaXN0ZXJzIHdoZW4gbmVj
ZXNzYXJ5KS4NCj4+DQo+PiBUaGVuIGR1cmluZyBwcm9iZSwgaW4gQVBJICJnZXRfcGh5X2Rldmlj
ZSIsIGl0IHNraXBzIHJlYWRpbmcgQzQ1IElEcy4NCj4+DQo+PiBTbyB0aGF0IGdlbnBoeV9jNDVf
cG1hX3JlYWRfYWJpbGl0aWVzIHNraXAgdGhlIHN1cHBvcnRlZCBmbGFnDQo+PiBFVEhUT09MX0xJ
TktfTU9ERV9BdXRvbmVnX0JJVC4NCj4gVGhpcyBzb3VuZHMgbGlrZSBhIGdlbmVyaWMgcHJvYmxl
bSwgd2hpY2ggd2lsbCBhZmZlY3QgYW55IFBIWSB3aGljaA0KPiBoYXMgYm90aCBDMjIgYW5kIEM0
NS4gSSB3b3VuZGVyIGlmIGl0IG1ha2VzIHNlbnNlIHRvIGFkZCBhIGhlbHBlcg0KPiBmdW5jdGlv
biB3aGljaCBhIFBIWSBkcml2ZXIgY2FuIGNhbGwgdG8gZ2V0IHRoZQ0KPiBwaHlkZXYtPmM0NV9p
ZHMubW1kc19wcmVzZW50IHBvcHVsYXRlZD8NCg0KSSB0aG91Z2h0IHRvIHVzZSBnZXRfcGh5X2M0
NV9pZHMgaW4gZ3B5X2NvbmZpZ19pbml0IHRvIHBvcHVsYXRlIHRoZSANCmM0NV9pZHMsIGJ1dCB0
aGlzIGlzIGEgc3RhdGljIGZ1bmN0aW9uIGluc2lkZSBwaHlfZGV2aWNlLmMuDQoNCk9yIG1heWJl
IGluIGdlbnBoeV9jNDVfcG1hX3JlYWRfYWJpbGl0aWVzLCBpdCByZWFkcyBNSUlfQk1TUiByZWdp
c3RlciBpZiANCmlzX2M0NSBub3Qgc2V0Lg0KDQo+Pj4+ICtzdGF0aWMgaW50IGdweV9yZWFkX3N0
YXR1cyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPj4+PiArew0KPj4+PiArICAgICBpbnQg
cmV0Ow0KPj4+PiArDQo+Pj4+ICsgICAgIHJldCA9IGdlbnBoeV91cGRhdGVfbGluayhwaHlkZXYp
Ow0KPj4+PiArICAgICBpZiAocmV0KQ0KPj4+PiArICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+
Pj4+ICsNCj4+Pj4gKyAgICAgcGh5ZGV2LT5zcGVlZCA9IFNQRUVEX1VOS05PV047DQo+Pj4+ICsg
ICAgIHBoeWRldi0+ZHVwbGV4ID0gRFVQTEVYX1VOS05PV047DQo+Pj4+ICsgICAgIHBoeWRldi0+
cGF1c2UgPSAwOw0KPj4+PiArICAgICBwaHlkZXYtPmFzeW1fcGF1c2UgPSAwOw0KPj4+PiArDQo+
Pj4+ICsgICAgIGlmIChwaHlkZXYtPmF1dG9uZWcgPT0gQVVUT05FR19FTkFCTEUgJiYgcGh5ZGV2
LT5hdXRvbmVnX2NvbXBsZXRlKSB7DQo+Pj4+ICsgICAgICAgICAgICAgcmV0ID0gZ2VucGh5X2M0
NV9yZWFkX2xwYShwaHlkZXYpOw0KPj4+PiArICAgICAgICAgICAgIGlmIChyZXQgPCAwKQ0KPj4+
PiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4+Pj4gKw0KPj4+PiArICAgICAg
ICAgICAgIC8qIFJlYWQgdGhlIGxpbmsgcGFydG5lcidzIDFHIGFkdmVydGlzZW1lbnQgKi8NCj4+
Pj4gKyAgICAgICAgICAgICByZXQgPSBwaHlfcmVhZChwaHlkZXYsIE1JSV9TVEFUMTAwMCk7DQo+
Pj4+ICsgICAgICAgICAgICAgaWYgKHJldCA8IDApDQo+Pj4+ICsgICAgICAgICAgICAgICAgICAg
ICByZXR1cm4gcmV0Ow0KPj4+PiArICAgICAgICAgICAgIG1paV9zdGF0MTAwMF9tb2RfbGlua21v
ZGVfbHBhX3QocGh5ZGV2LT5scF9hZHZlcnRpc2luZywgcmV0KTsNCj4+PiBjYW4gZ2VucGh5X3Jl
YWRfbHBhKCkgYmUgdXNlZCBoZXJlPw0KPj4gMi41RyBpcyBub3QgY292ZXJlZCBpbiBnZW5waHlf
cmVhZF9scGEuDQo+Pg0KPj4gSWYgSSB1c2UgZ2VucGh5X2M0NV9yZWFkX2xwYSBmaXJzdCB0aGVu
IGdlbnBoeV9yZWFkX2xwYSBhZnRlciwgaXQgc2VlbXMNCj4+IGEgYml0IHJlZHVuZGFudC4NCj4g
SSdtIGp1c3QgdHJ5aW5nIHRvIGF2b2lkIHJlcGVhdGluZyBjb2RlIHdoaWNoIGlzIGluIGhlbHBl
cnMuIEkgdGhpbmsNCj4gdGhpcyBpcyB0aGUgZmlyc3QgUEhZIGRyaXZlciB3aGljaCB1c2VzIGEg
bWl4dHVyZSBvZiBDMjIgYW5kIEM0NSBsaWtlDQo+IHRoaXMuIFNvIGl0IGNvdWxkIGJlIHRoZSBo
ZWxwZXJzIG5lZWQgc21hbGwgbW9kaWZpY2F0aW9ucyB0byBtYWtlIHRoZW0NCj4gd29yay4gV2Ug
c2hvdWxkIG1ha2UgdGhvc2UgbW9kaWZpY2F0aW9ucywgc2luY2UgeW91ciBQSFkgaXMgbm90IGxp
a2VseQ0KPiB0byBiZSB0aGUgb25seSBtaXhlZCBDMjIgYW5kIEM0NSBkZXZpY2UuDQoNCkkgYWdy
ZWUsIHRoaXMgaXMgaXNzdWUgZm9yIG1peGVkIEMyMi80NSBkZXZpY2UuDQoNCkkgc2F3IHNvbWV0
aGluZyBzaW1pbGFyIGluIEJSQ00gZHJpdmVyIChiY204NDg4MV9yZWFkX3N0YXR1cykgYW5kIA0K
TWFydmVsbCBkcml2ZXIgKG12MzMxMF9yZWFkX3N0YXR1c19jb3BwZXIpLg0KDQpUaGV5IGFyZSBD
NDUgZGV2aWNlIGFuZCB1c2UgdmVuZG9yIHNwZWNpZmljIHJlZ2lzdGVyIGluIE1NRCB0byBhY2Nl
c3MgDQpDMjIgZXF1aXZhbGVudCByZWdpc3RlcnMuDQoNCj4NCj4gICAgIEFuZHJldw0KPg0KDQo=

