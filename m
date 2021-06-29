Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4133B763A
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 18:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhF2QKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 12:10:22 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:41210 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232257AbhF2QIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 12:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1624982738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLFbQt3/BKDVl7YsAllqrHZEuNb9Nx52sj4Yu3FMrT4=;
        b=CuB2KxHqGuoO1RwCwwIn7N9D1zSSFTGcKKsRayh+n3s/VHx75LxAazKVRLcXxx3A5dut+b
        csmlBZig14Mz62mMBgehB6xI9iWrGaHj5zxtAjjM6qLBuEeyI+IEm0e6Nafal74zDaSWK/
        XWaPKAJI53u2tLOUvaXLYcSb0SHejdo=
Received: from NAM04-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam08lp2048.outbound.protection.outlook.com [104.47.74.48]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-oQTP2I_-MOy6N3dZ9T0u1A-1; Tue, 29 Jun 2021 12:05:35 -0400
X-MC-Unique: oQTP2I_-MOy6N3dZ9T0u1A-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MW3PR19MB4345.namprd19.prod.outlook.com (2603:10b6:303:49::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 16:05:33 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4219.024; Tue, 29 Jun 2021
 16:05:33 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH v4 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v4 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXbCotGaKisHiq60uUI9dpHq7kBqsrFh6AgAASuYA=
Date:   Tue, 29 Jun 2021 16:05:33 +0000
Message-ID: <6068f6ab-1521-48be-20a6-f8a30ad75d3f@maxlinear.com>
References: <20210628142946.16319-1-lxu@maxlinear.com>
 <20210628142946.16319-2-lxu@maxlinear.com> <YNs1F7pgNzDlm/mD@lunn.ch>
In-Reply-To: <YNs1F7pgNzDlm/mD@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [138.75.37.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48dfaf3a-76af-4b99-8c8e-08d93b17b9d9
x-ms-traffictypediagnostic: MW3PR19MB4345:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR19MB4345D6350E74931F8A589966BD029@MW3PR19MB4345.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lHPmVyoUItb6yxAbJv8mPBvpFDI1+D6W9fB9oMV2d67VpLiCwymFWZR4PljkrmD1nSm35cev2CtL5me71JY2MD0T66Td990zNF4l5ZspX//yRk7bCxGM3xZt/R4tIfPh1Ng7miGBqJfo52vBRhZtm14Z78WlYe1ekzWrwHuchuqEWsB5RyV0EDjNB20+yWQejOYOXI63QLlgCaeea4LfMMyw0tjsgS8Bl5mGUQl7ontGmtJhWvo+tjnEhnLGfLXquSUHZKmKe7vCCMz12opeCVZ5QsxduIzrSRZS9foOONpC2IU4sUWuX4loc2NgXmibixdPjbQjay0L2DG+MrhDjOV1gleVF0Syd1oKIcNcD0amVQ4n4ItpbHpkHVdCWK+G11GYnnlwnsYe2lIYYL4vRmwkc4PZDZCNKDfbjWJrIHWu6q7t+n3qY5lJGGfEKGTzyYxf7gg8sKrWQyLiyPJ6NSVxSDvjzx5UfPXAl3PHaHnsd/ANYFd4pYfky+j/AzxpSeiCdj7ftk0oyV8oGJrnoq9ugE9VsNKSSQ3KwwEp3RrEz4Gho6RjQ7feABdcb7NWZFGADqo/4NwckkT6q48T7xRP2ZgNqAld8Dzi5xitfwVfk8XvhLhuyKFJ+mlQs5pFVz8qCTJmPUKclbfgY9rVMOalGHJQB9B6d8pAr7txWWnmR6xzcnohSt9aloNC8/J+E+aTrkhXN99ml/spNH/OT5z1/eCD7DyOouviJayHk6I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39840400004)(366004)(396003)(346002)(6512007)(64756008)(6916009)(66476007)(2616005)(91956017)(66946007)(86362001)(2906002)(66446008)(5660300002)(76116006)(26005)(186003)(66556008)(83380400001)(36756003)(53546011)(316002)(6486002)(122000001)(4326008)(38100700002)(8676002)(54906003)(31686004)(71200400001)(6506007)(478600001)(31696002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjVqVEdydGUrakNPdkZwaDJnQVZaVys0bmJNcVhXZjRrZkYyUVE1OGcybUZ2?=
 =?utf-8?B?Zys2ZGg3NFVnNUtNWkZ3T2pwL3JrSzc1eFVURWdIRDlkSUdUWlU5VHo3cE1q?=
 =?utf-8?B?UUVER2UwbjZ4OXM1Z1FWaDVHMS9KREZublMzckg4TDI1OExFYk5YQ2JrQUhn?=
 =?utf-8?B?YnRORzZTbG44RjFmVEVacnV0bDFpSW9WeGMwWkt4SFhCNTNuNU1iYlRhTFYy?=
 =?utf-8?B?MmRLVW51YWk3MVlCcUpnRGNIc0Q1Z0g5VlBuU1BOVk9QWktZZlZNUzJlTi81?=
 =?utf-8?B?ak9nZW9GUnZHOUVlS0Y3aTczeFJpYll6dTJGSXRiNWttN01QTWdRZ09xUjQ4?=
 =?utf-8?B?UlprTmRlYXJaNEprWklnREFWUGRKa3Bqc1prWkJObUVuUlFBVVZqVWhQRWQ2?=
 =?utf-8?B?L1I5OTlMbzVZcGQzZXBoTzdqYWl6RXA5RDBMblViMEZwYnRhbDZ2Wm16bjBB?=
 =?utf-8?B?MU5ORXZFR0ZORXBSNUhPUiszcklNUFF2R3JRcXVzam1ZUTM3YUhNSVJ2WDRx?=
 =?utf-8?B?SHF5M2ZMZTZrS3VXTDJaVklpbGpmWENmaWtZN0dlS1N1SGhoeUQxNDY3RHFP?=
 =?utf-8?B?STVkNGM3eWRUK3hHWHhta0lSNGd2RjRZQ0pEbTQ3dFVMNWRialJ3L2N3K2tI?=
 =?utf-8?B?ZURQc2w2VVR5cHhEbUw0bnNnVXU2dWNlOWJVeWlncGxMQnNiSmY1MjFkMEo1?=
 =?utf-8?B?aEk3WE1ENmZZVnoreVdOSFFmSDFVNGxBYUpjSHJtb0dPdGtjdjJsR3pRNEYy?=
 =?utf-8?B?SWZlV0RnSzR0Q0NLK210N2ZzVGprdXkyYzJETC9BUDJjd2JPeHZiRncvU05G?=
 =?utf-8?B?UUJLaXFHVkU3RUVldHRSNWJhVVRNbkhDbVRLOEc3enJ0cnZDS0tGZjk4bjEw?=
 =?utf-8?B?ZjNiYUJ1a1RFaGV3czFsSENLWXBGR29ZQ0ZEWDgzLytadWt4RG1xVUpOaG9l?=
 =?utf-8?B?Q2NOWWlYN084ZjUzN1dabHRHVnp6a0pnRzFoMzBoclVsZzc1STdkS0pSRkh2?=
 =?utf-8?B?MmJBcklWVG82eWNGZEpPMTIrdmczZXZPS3I0QTJnZzIzWHNPR29iQzB3dC9M?=
 =?utf-8?B?dm51aTJZQ29ZT0o1eWJDS2czVStpRTcvQmF6Z054emJvYlFqbGd4c2xPOEtE?=
 =?utf-8?B?cFFFakdCaGdQa1d6dUVVY20rYlpzVmNqU0ExODlxcTNpSVRDd3hPRU03VFVo?=
 =?utf-8?B?bXFkbElIZ2JTOGtoQXhCc0ZCREtCU1pDeGVxNnlQTFdVZW5iN1NEUHMzSWcv?=
 =?utf-8?B?NnFGKzdnYkJWL282ajNSZEQzaHcreHZHcjRGL3ArRHpWcVFHb25rMkNGUGpN?=
 =?utf-8?B?SWVZYTA4SzZWNk5GT2JZRlh5aWJLQTNQS0VXNmZqS2tySUVBNXNhaXRQUnMw?=
 =?utf-8?B?bzhpclBMa1FMWFNuMmZOWWhLRElFbTMyTjJrdmlIR0syQU9BSS9EVW5iYm9h?=
 =?utf-8?B?NEdpZGhZU3Y3SkY4dFZrK2FRM0FJem9FbytXQThQMEV6eEJ1T0FPMUR2Smc5?=
 =?utf-8?B?bXZkTlNQUVhtSUV1clE3WmlOYXd1Ung5NDhTUnhpM2xpSkpGSFdWd3BKQmJN?=
 =?utf-8?B?SGt1RmhKVXI0K25teW9VdVNYOHplRUFsK0N3UDEvVmR0K1FscEZhak5wRk0v?=
 =?utf-8?B?Y1lkNExHL0NvandsdEprZUE1RkJwK2FFSVh6Q1A4a25uOEIxbHR5cUlLblJo?=
 =?utf-8?B?SFhNTXlWQlR2VmxuM240N1l6U01jaVBYNDZCRnRDRVJlOWNUaG1FNit6Ullx?=
 =?utf-8?Q?8t8tI7A/QcdEtqvZX8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48dfaf3a-76af-4b99-8c8e-08d93b17b9d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2021 16:05:33.6055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DISCSqEdkNcupwh2CdmbM6Qy8RbeOEst6KY6iiX9YBdXYz4aUdqhPQ/XvPTfh9tFQhCG03OkaTcRuI/DMMKeVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR19MB4345
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <8D689081522BBB45B1867D9A546B6879@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjkvNi8yMDIxIDEwOjU4IHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gVGhpcyBlbWFpbCB3
YXMgc2VudCBmcm9tIG91dHNpZGUgb2YgTWF4TGluZWFyLg0KPg0KPg0KPj4gK3N0YXRpYyBpbnQg
Z3B5X2NvbmZpZ19hbmVnKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiArew0KPj4gKyAg
ICAgYm9vbCBjaGFuZ2VkID0gZmFsc2U7DQo+PiArICAgICB1MzIgYWR2Ow0KPj4gKyAgICAgaW50
IHJldDsNCj4+ICsNCj4+ICsgICAgIGlmIChwaHlkZXYtPmF1dG9uZWcgPT0gQVVUT05FR19ESVNB
QkxFKSB7DQo+PiArICAgICAgICAgICAgIC8qIENvbmZpZ3VyZSBoYWxmIGR1cGxleCB3aXRoIGdl
bnBoeV9zZXR1cF9mb3JjZWQsDQo+PiArICAgICAgICAgICAgICAqIGJlY2F1c2UgZ2VucGh5X2M0
NV9wbWFfc2V0dXBfZm9yY2VkIGRvZXMgbm90IHN1cHBvcnQuDQo+PiArICAgICAgICAgICAgICAq
Lw0KPj4gKyAgICAgICAgICAgICByZXR1cm4gcGh5ZGV2LT5kdXBsZXggIT0gRFVQTEVYX0ZVTEwN
Cj4+ICsgICAgICAgICAgICAgICAgICAgICA/IGdlbnBoeV9zZXR1cF9mb3JjZWQocGh5ZGV2KQ0K
Pj4gKyAgICAgICAgICAgICAgICAgICAgIDogZ2VucGh5X2M0NV9wbWFfc2V0dXBfZm9yY2VkKHBo
eWRldik7DQo+PiArICAgICB9DQo+PiArDQo+PiArICAgICByZXQgPSBnZW5waHlfYzQ1X2FuX2Nv
bmZpZ19hbmVnKHBoeWRldik7DQo+PiArICAgICBpZiAocmV0IDwgMCkNCj4+ICsgICAgICAgICAg
ICAgcmV0dXJuIHJldDsNCj4+ICsgICAgIGlmIChyZXQgPiAwKQ0KPj4gKyAgICAgICAgICAgICBj
aGFuZ2VkID0gdHJ1ZTsNCj4+ICsNCj4+ICsgICAgIGFkdiA9IGxpbmttb2RlX2Fkdl90b19taWlf
Y3RybDEwMDBfdChwaHlkZXYtPmFkdmVydGlzaW5nKTsNCj4+ICsgICAgIHJldCA9IHBoeV9tb2Rp
ZnlfY2hhbmdlZChwaHlkZXYsIE1JSV9DVFJMMTAwMCwNCj4+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBBRFZFUlRJU0VfMTAwMEZVTEwgfCBBRFZFUlRJU0VfMTAwMEhBTEYsDQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWR2KTsNCj4+ICsgICAgIGlmIChyZXQgPCAw
KQ0KPj4gKyAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPj4gKyAgICAgaWYgKHJldCA+IDApDQo+
PiArICAgICAgICAgICAgIGNoYW5nZWQgPSB0cnVlOw0KPj4gKw0KPj4gKyAgICAgcmV0ID0gZ2Vu
cGh5X2M0NV9jaGVja19hbmRfcmVzdGFydF9hbmVnKHBoeWRldiwgY2hhbmdlZCk7DQo+PiArICAg
ICBpZiAocmV0IDwgMCkNCj4+ICsgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4+ICsNCj4+ICsg
ICAgIGlmIChwaHlkZXYtPmludGVyZmFjZSA9PSBQSFlfSU5URVJGQUNFX01PREVfVVNYR01JSSB8
fA0KPj4gKyAgICAgICAgIHBoeWRldi0+aW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9J
TlRFUk5BTCkNCj4+ICsgICAgICAgICAgICAgcmV0dXJuIDA7DQo+PiArDQo+PiArICAgICAvKiBO
byBuZWVkIHRvIHRyaWdnZXIgcmUtQU5FRyBpZiBTR01JSSBsaW5rIHNwZWVkIGlzIDIuNUcNCj4+
ICsgICAgICAqIG9yIFNHTUlJIEFORUcgaXMgZGlzYWJsZWQuDQo+PiArICAgICAgKi8NCj4gSXMg
dGhpcyBjb3JyZWN0LiBBcmUgeW91IHVzaW5nIFNHTUlJIGF0IDIuNUcsIG9yIHNob3VsZCB0aGlz
IGNvbW1lbnQNCj4gYmUgMjUwMEJhc2VYPw0KPg0KPiBPdGhlcndpc2UsIHRoaXMgbG9va3MgZ29v
ZCBub3cuDQo+DQo+ICAgICBBbmRyZXcNCj4NCkNhbiBJIGNoYW5nZSB0byAiaWYgbGluayBzcGVl
ZCBpcyAyLjVHIj8NCg0KDQo=

