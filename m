Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A73066AD1C
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjANRos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjANRor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:44:47 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE99CA5F0
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:44:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEvI1YReh3/Lyqb8sr+1Jj7hkWAI5ZwYkCfPZ95LDSnlFhpC3qGZWDYRJlmOq7nypRtCS/OqyINwUXxfkoPSojWi2qWz05Zf3w+8j1l0qHWXQ30qqYs3zjJouvWodEYIwmdalT+v2yQDzTpvG+3zU7wC29RwjCEPicEc2w1VVtV9HtN5jl7SjtiqYhMKbOAXH8Vxt3FlRVeDjF2moyKxVwubR/6Rkbk5g6aFUn/NYjeesSEvKkqHYUaC+Eg6HJkC/MFB34V9wS+NAIgj3yu7xo+MSAnIQWwobCBMiQ5QZadkGlmFEGmugfPxxtgnbJpM6Z6QpyVWeSHsLCaog0dt4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QciyE/TYc2HoLG4hqHZ9ZaFEya9Xotol0Vo81w2poxU=;
 b=X6i90G2tEpLkMzvc+45nFZTPcwNw0DmPn4iEI0ctrP26t/ojhhY1bXBppryvNt9p3AIY1+zWohoR21Umq08gr0GaxR1/bqFfgvMW7nlV5ClK1uZElCctx/v21lXllY7LEAqAUedeX0fapYuRQzClZX2giMtqOBT/oJ/uwbA9DWQG2fZZjZw8YiMDDkOI+sentYZ4XOssfUNr1M1ca7lp1A5MlZIQWIFaJLKedfAC5R2BzCf9ZAE8Pw5JRe8L+SK6RA7l+gEGDYClOxyuG5c/edj/ls69Q+6ipsrX5/3gqUPTzNO49NxJCbn3XlklKH9hcRQVT7V9mVXsYzmp0br+kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QciyE/TYc2HoLG4hqHZ9ZaFEya9Xotol0Vo81w2poxU=;
 b=eOqliBZ45RpP5epk6+BVG82yGBVh6jmVyLLOFhyxlCAMX10tri0AJC+y7zFpekS+MRXcodCnNUpXNjqXPjTOidJQ38IJvpDsiwYKnkSKpVRQsv6UyuwG9qULLvY8/bmHTlCm9gSGC3iMAPxs0BiM3+5z3SlvJphF4QEh8qmfzfYFBddtSW19Orqa0bs2K0Hji+zo5pynNUW9Z/vPDAxM89ikhZvqo0mlgHhp5iPcQzNcl9ldT1uKsrQm35ewVeWh9JUIaBKAdJJ/+kS7EnRlryfIuoUws/Cxs2JjWKIbjuSUV0zrvJ7ULJiQGVSn8kt5zqnve3WeWsq8faQnkKDXng==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CH0PR12MB5172.namprd12.prod.outlook.com (2603:10b6:610:bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Sat, 14 Jan
 2023 17:44:42 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::a891:beb7:5440:3f0%5]) with mapi id 15.20.5986.023; Sat, 14 Jan 2023
 17:44:42 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH net-next 1/2] virtio_net: Fix short frame length check
Thread-Topic: [PATCH net-next 1/2] virtio_net: Fix short frame length check
Thread-Index: AQHZJ5+K3DKVg5aInUyA+MiyhrF1eK6c/Q6AgAAAlzCAAA/+AIABD7+Q
Date:   Sat, 14 Jan 2023 17:44:42 +0000
Message-ID: <PH0PR12MB5481299265978E6719F92A76DCC39@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230113223619.162405-1-parav@nvidia.com>
 <20230113223619.162405-2-parav@nvidia.com>
 <92b98f45dcd65facac78133c6250d9d96ea1a25f.camel@gmail.com>
 <PH0PR12MB5481C03EDED7C2D67395FCA4DCC29@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CAKgT0UenRh4gdcOOg3t7+JXXyu06daXE8U8a38oxUQWQ3UnQVg@mail.gmail.com>
In-Reply-To: <CAKgT0UenRh4gdcOOg3t7+JXXyu06daXE8U8a38oxUQWQ3UnQVg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CH0PR12MB5172:EE_
x-ms-office365-filtering-correlation-id: a59877a9-eb81-4aa9-63e9-08daf6570479
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MGpa60gHJYrLS+IdxxPzbAuRXJmKZfBHR/VNZeFaEqjTRFJ1Xxj8hpX65CMZH2/dNR5yEf38R4l3xTLGV5Uycupprc1c/seAE/jqZty6PY5qxWv9mVQITPgb8KqM4BPovVidzIed74EipqikeHdSBa77bjbCx0YkLOuPKoprvbVdJUTsqgV/bt+c2FKX9y56Z7q7CepGIByPfWICeuqyeikjYWc+bhEy8brAUCo5RIRE7y4dbpTd+B1ghtTG/I8Ul3gHHoRa8/niKp5LuvpqQA+Ot3GSDq6P1uc1WDfUjJCEswISryrCXH4JBiCFIluSdzVmv7+NkgsPpHT32m4AzAbvQODFpVvUil0X0o911ac7F4jkJR0QP8DbrqgVqXOQc7UFZKo8qbLQW+SXF1SPQbpsH82ZsV1NOlv1QGqk6P+IusgSLDDqG1+wEfveUIW414VzlEJNq9njFdQljH8MZON++aMfV0OvXGG1hHltnursYG1Kf5486yjFE6vBqAdwMLlTtPQ4ypGJPJj3f230sdVqX5/wv4IZme3kIRkh0vuxWjByfn7Gn2jI1G26GrotqjXuSRtaAT/H9ngwi4sybHVPov4otSxrvXqXmLbquHA3XPoC2LQaS6i0MCgJUZOXqlaE8lhkQrwqKR4XEs86VK3MLN8cfagqNBVwNPeyn8m1xSN3SuQoJBhVh47zgtTCg2lqrbF0m2gOfuEFHGNvSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199015)(6506007)(2906002)(53546011)(122000001)(76116006)(5660300002)(52536014)(8936002)(8676002)(4326008)(6916009)(64756008)(83380400001)(66446008)(38100700002)(9686003)(478600001)(41300700001)(38070700005)(33656002)(186003)(66946007)(66476007)(7696005)(55016003)(71200400001)(66556008)(86362001)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Skpkdkg0RVdxTDNkb2NiK3EvRzNnT3dwQ0M1UzBWZEllK045TTRtZ0I1akZy?=
 =?utf-8?B?a0ROaUFOKy9QcDVva1NuYnBOVmJUVWZ2UU0wUGU2UkdRbjc1bmR6RHl0cHU0?=
 =?utf-8?B?d0I2c2dSdTdTbERTbUxtR1hyNkVRTnNFYTA3OW5qSWt5NUllRTUveXFsZnla?=
 =?utf-8?B?RFNINnZiS1daUitteGJYNmxOcGVkR3J6WG54MUc1dTVpdGJHTERqUEErNVRr?=
 =?utf-8?B?a2J2KzJVTHdYTFA1MHNlQkdnNTVMeDdmUHdFbVVnTVk2MW9SbG1OSmVSV1Rx?=
 =?utf-8?B?Ny81NG1SSTkwcVcwQUh1SDdVNlZLUUFtb2Vvd2l5Ti9zYnV2czdPMU8weGdu?=
 =?utf-8?B?MXArOUZabng4cDl0Q1NKNmplS2F2QlloT2Y5Yk5TWEVXc0p4bWFlUFgxLzhC?=
 =?utf-8?B?R2gwaCsySmFVaUc5c1g3QndiR3BNR2MrRGNXZ2o2MkxKa2daZ1FHM0lwaFNl?=
 =?utf-8?B?SmpIRjdMd3h5Z1ZuN1RWZFp5TGFaSVpjQXRDbkdiSjlUQVZhZXRTNmdONENh?=
 =?utf-8?B?UWRzOW4vNDNocXFsZWdsRVBWQU4ydFJyN2UwTG0zUWZnbzdRNmRzUmt5QnBu?=
 =?utf-8?B?c0g1bWFHOUtFS1hzT2lWUVZCSU5UK1V5NDJiV04yb3lSQm1iUnc4YnRBMjdp?=
 =?utf-8?B?Tmd1REFtRVNyNVVSb3kybndlMWx3SFhkb1NuMWozTElOMDZudHhlM3krbWp4?=
 =?utf-8?B?VHg1RUpyWDlBaXNWem0rV1lCYUVmSUJ6OTlQVnFNSUY1TjNMcFhNQk5oaEh4?=
 =?utf-8?B?WXRBWUVrUlRQRk5ueHE0ZWJDTGRoOENsdENhdmR6cjVhQkV3RmpTUVNDaW9u?=
 =?utf-8?B?ZDBkRGpQSURXanQ2SXZyemc1UFVqcXhSWWZFbmFFTk8zY0x6ZnBxUDJIdUpr?=
 =?utf-8?B?a0tkWEhtUTA4V1dHb2tTYzF6VlNHbjVtZTg4SE1RZW9MTnh4RWp2ZzZPZzVT?=
 =?utf-8?B?cHZBNTByOGpsLzhYRFVYSzBlZmRlUTVEa0YzT0p6SWpaT0VnVHAzcW5iR3VM?=
 =?utf-8?B?UXZseGZSS24wemgvMGJhWWExcWtveDU4MmdFUC9nSUhCYWNBZC9FZDkycE1V?=
 =?utf-8?B?TGV6VTBhRlVFbE5uWnBZZmhNMmxRS2ZPNUJWSGRacXJsSWpMQVhWS0VWc3l1?=
 =?utf-8?B?Y2YwVWV1MlhDdXJCR2UrV3B4MllidlNoRHpqNkpoazEvUEpLa3hRQTJLb2wy?=
 =?utf-8?B?ZUhtUHFtQVZCOTdxTHdZT1RkcVFjejdxWGdySkF2bVduKzZkS3JJZmNQQlhp?=
 =?utf-8?B?eVRWL1ZHVEIyUmdxOWM2TEVMdUVmemswMmpFd0EvOEdiMHVzUFNvWjFLcGRi?=
 =?utf-8?B?cm9CSTJ1T0ZTZ0RVdUhUaDdBL2p6M1V1V2NJNitwanIvUjRFV1NBa1pqU3R3?=
 =?utf-8?B?ZzkrMGoySjhVdGFqQWVteW9HcjZBV0Vsdi9qM1JpdE8rbnlSYVpEUXdQc2Qy?=
 =?utf-8?B?RyticUdNUnI2cENoTDVzVy9ycStUUGIwVmlYMmRSVUhCMXA3SFhSVmpGbzBL?=
 =?utf-8?B?b2x2RzRuZ3lybHcvaGRQTmFPYjJKeUZlM0E1bHZCMk1Jc0ZMM3ZwQ0sycmRx?=
 =?utf-8?B?UDFCNlhqa3lyemkrenJuRjJSbTZ6ZStBcFQ5UEZPTm9GUmlsQy80d0F0eXpq?=
 =?utf-8?B?YTFXcXN0WWsyZ25hbHM3dzNHcGthNTNRK1QvVmcyYU8xcHhWeUtTd2JxUGpM?=
 =?utf-8?B?cjhybmRBWW82WHFYakg2ZEdPSDcrTjZ2Y1J1YnhPWUsvamRCWGczc29aOUUz?=
 =?utf-8?B?azRKM2lRUVB4VjRQNlk3NFpQWnc0VmJiUXBDSmljNEo3MEMyYjg2QjV1b1Rz?=
 =?utf-8?B?YXoyeHpSWmxScEFaQVprVkdyZFBGS3ZKL0xpOVJyRExFZkJxa29Qb0hmZ2dj?=
 =?utf-8?B?RldKbVBmWFhOQkY1MVExOXhwUkxvZjNYWHRGWEhrTGhVcXNIL0pGbGUveVVz?=
 =?utf-8?B?OXBDZ0dOZnNzbkZHTE1zcnRMMFVGTU9UKzQ4YlBQTnV2N3VvYTVLa3ZIcXdE?=
 =?utf-8?B?TGd0ZUQ3T3FTdE9yZGFoRi9SY3JxM2V0dUxXNWxWUlR1UHJqT1ozZ3V0YW14?=
 =?utf-8?B?L1ozZHNIM0ZrZ25KTlNzbGtlWVFRY3hhMnlJYVF0YmJ2NzFlNVpiVEFDMitR?=
 =?utf-8?B?WVFmcGpmbTVqWTRBc0RaemlYaGdoSDc3T0FhZWVyYUV2d1Z6VllCa1FpQklT?=
 =?utf-8?Q?aFgF9RkKI185CvrMxSeTUTY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a59877a9-eb81-4aa9-63e9-08daf6570479
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2023 17:44:42.3373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68kqj7alpZJ4K2ooAqHMPHlJYBxAh/mbTEHAu7rzqS2YMrdzvBxmCg5Rzq/YOs9acQI5KuIotFVU/GxsCP81nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5172
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4NCj4g
U2VudDogRnJpZGF5LCBKYW51YXJ5IDEzLCAyMDIzIDc6MjQgUE0NCj4gDQo+IE9uIEZyaSwgSmFu
IDEzLCAyMDIzIGF0IDM6MzcgUE0gUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEuY29tPiB3cm90
ZToNCj4gPg0KPiA+DQo+ID4gPiBGcm9tOiBBbGV4YW5kZXIgSCBEdXljayA8YWxleGFuZGVyLmR1
eWNrQGdtYWlsLmNvbT4NCj4gPiA+IFNlbnQ6IEZyaWRheSwgSmFudWFyeSAxMywgMjAyMyA2OjI0
IFBNDQo+ID4gPg0KPiA+ID4gT24gU2F0LCAyMDIzLTAxLTE0IGF0IDAwOjM2ICswMjAwLCBQYXJh
diBQYW5kaXQgd3JvdGU6DQo+ID4gPiA+IEEgc21hbGxlc3QgRXRoZXJuZXQgZnJhbWUgZGVmaW5l
ZCBieSBJRUVFIDgwMi4zIGlzIDYwIGJ5dGVzDQo+ID4gPiA+IHdpdGhvdXQgYW55IHByZWVtYmxl
IGFuZCBDUkMuDQo+ID4gPiA+DQo+ID4gPiA+IEN1cnJlbnQgY29kZSBvbmx5IGNoZWNrcyBmb3Ig
bWluaW1hbCAxNCBieXRlcyBvZiBFdGhlcm5ldCBoZWFkZXIgbGVuZ3RoLg0KPiA+ID4gPiBDb3Jy
ZWN0IGl0IHRvIGNvbnNpZGVyIHRoZSBtaW5pbXVtIEV0aGVybmV0IGZyYW1lIGxlbmd0aC4NCj4g
PiA+ID4NCj4gPiA+ID4gRml4ZXM6IDI5NmY5NmZjZmMxNiAoIk5ldCBkcml2ZXIgdXNpbmcgdmly
dGlvIikNCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogUGFyYXYgUGFuZGl0IDxwYXJhdkBudmlkaWEu
Y29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIGRyaXZlcnMvbmV0L3ZpcnRpb19uZXQuYyB8IDIg
Ky0NCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdmlydGlvX25ldC5j
IGIvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jDQo+ID4gPiA+IGluZGV4DQo+ID4gPiA+IDc3MjNi
MmE0OWQ4ZS4uZDQ1ZTE0MGI2ODUyIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC92
aXJ0aW9fbmV0LmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jDQo+ID4g
PiA+IEBAIC0xMjQ4LDcgKzEyNDgsNyBAQCBzdGF0aWMgdm9pZCByZWNlaXZlX2J1ZihzdHJ1Y3Qg
dmlydG5ldF9pbmZvDQo+ID4gPiA+ICp2aSwNCj4gPiA+IHN0cnVjdCByZWNlaXZlX3F1ZXVlICpy
cSwNCj4gPiA+ID4gICAgIHN0cnVjdCBza19idWZmICpza2I7DQo+ID4gPiA+ICAgICBzdHJ1Y3Qg
dmlydGlvX25ldF9oZHJfbXJnX3J4YnVmICpoZHI7DQo+ID4gPiA+DQo+ID4gPiA+IC0gICBpZiAo
dW5saWtlbHkobGVuIDwgdmktPmhkcl9sZW4gKyBFVEhfSExFTikpIHsNCj4gPiA+ID4gKyAgIGlm
ICh1bmxpa2VseShsZW4gPCB2aS0+aGRyX2xlbiArIEVUSF9aTEVOKSkgew0KPiA+ID4gPiAgICAg
ICAgICAgICBwcl9kZWJ1ZygiJXM6IHNob3J0IHBhY2tldCAlaVxuIiwgZGV2LT5uYW1lLCBsZW4p
Ow0KPiA+ID4gPiAgICAgICAgICAgICBkZXYtPnN0YXRzLnJ4X2xlbmd0aF9lcnJvcnMrKzsNCj4g
PiA+ID4gICAgICAgICAgICAgaWYgKHZpLT5tZXJnZWFibGVfcnhfYnVmcykgew0KPiA+ID4NCj4g
PiA+IEknbSBub3Qgc3VyZSBJIGFncmVlIHdpdGggdGhpcyBjaGFuZ2UgYXMgcGFja2V0cyBhcmUg
b25seSA2MEIgaWYNCj4gPiA+IHRoZXkgaGF2ZSBnb25lIGFjcm9zcyB0aGUgd2lyZSBhcyB0aGV5
IGFyZSB1c3VhbGx5IHBhZGRlZCBvdXQgb24gdGhlDQo+ID4gPiB0cmFuc21pdCBzaWRlLiBUaGVy
ZSBtYXkgYmUgY2FzZXMgd2hlcmUgc29mdHdhcmUgcm91dGVkIHBhY2tldHMgbWF5IG5vdA0KPiBi
ZSA2MEIuDQo+ID4gPg0KPiA+IERvIHlvdSBtZWFuIExpbnV4IGtlcm5lbCBzb2Z0d2FyZT8gQW55
IGxpbmsgdG8gaXQgd291bGQgYmUgaGVscGZ1bC4NCj4gDQo+IFRoZSBwcm9ibGVtIGlzIHRoZXJl
IGFyZSBzZXZlcmFsIHNvZnR3YXJlIHBhdGhzIGludm9sdmVkIGFuZCB0aGF0IGlzIHdoeSBJIGFt
DQo+IHdhbnRpbmcgdG8gYmUgY2F1dGlvdXMuIEFzIEkgcmVjYWxsIHRoaXMgd291bGQgaW1wYWN0
IFFlbXUgaXRzZWxmLCBEUERLLCB0aGUNCj4gTGludXggS2VybmVsIGFuZCBzZXZlcmFsIG90aGVy
cyBpZiBJIGFtIG5vdCBtaXN0YWtlbi4gVGhhdCBpcyB3aHkgSSBhbSB0ZW5kaW5nIHRvDQo+IGVy
ciBvbiB0aGUgc2lkZSBvZiBjYXV0aW9uIGFzIHRoaXMgaXMgYSBwcmV0dHkgc2lnbmlmaWNhbnQg
Y2hhbmdlLg0KPiANCj4gPiA+IEFzIHN1Y2ggcmF0aGVyIHRoYW4gY2hhbmdpbmcgb3V0IEVUSF9I
TEVOIGZvciBFVEhfWkxFTiBJIHdvbmRlciBpZg0KPiA+ID4gd2Ugc2hvdWxkIGxvb2sgYXQgbWF5
YmUgbWFraW5nIHRoaXMgYSAiPD0iIGNvbXBhcmlzb24gaW5zdGVhZCBzaW5jZQ0KPiA+ID4gdGhh
dCBpcyB0aGUgb25seSBjYXNlIEkgY2FuIHRoaW5rIG9mIHdoZXJlIHRoZSBwYWNrZXQgd291bGQg
ZW5kIHVwDQo+ID4gPiBiZWluZyBlbnRpcmVseSBlbXB0eSBhZnRlciBldGhfdHlwZV90cmFucyBp
cyBjYWxsZWQgYW5kIHdlIHdvdWxkIGJlIHBhc3NpbmcNCj4gYW4gc2tiIHdpdGggbGVuZ3RoIDAu
DQo+ID4NCj4gPiBJIGxpa2VseSBkaWRu4oCZdCB1bmRlcnN0YW5kIHlvdXIgY29tbWVudC4NCj4g
PiBUaGlzIGRyaXZlciBjaGVjayBpcyBiZWZvcmUgY3JlYXRpbmcgdGhlIHNrYiBmb3IgdGhlIHJl
Y2VpdmVkIHBhY2tldC4NCj4gPiBTbywgcHVycG9zZSBpcyB0byBub3QgZXZlbiBwcm9jZXNzIHRo
ZSBwYWNrZXQgaGVhZGVyIG9yIHByZXBhcmUgdGhlIHNrYiBpZiBpdA0KPiBub3QgYW4gRXRoZXJu
ZXQgZnJhbWUuDQo+ID4NCj4gPiBJdCBpcyBpbnRlcmVzdGluZyB0byBrbm93IHdoZW4gd2UgZ2V0
IDwgNjBCIGZyYW1lLg0KPiANCj4gSWYgSSByZWNhbGwsIGEgVURQdjQgZnJhbWUgY2FuIGVhc2ls
eSBkbyBpdCBzaW5jZSBFdGhlcm5ldCBpcyAxNEIsIElQIGhlYWRlciBpcyAyMCwNCj4gYW5kIFVE
UCBpcyBvbmx5IDggc28gdGhhdCBvbmx5IGNvbWVzIHRvIDQyQiBpZiBJIHJlY2FsbCBjb3JyZWN0
bHkuIFNpbWlsYXJseSBJIHRoaW5rDQo+IGEgVENQdjQgRnJhbWUgY2FuIGJlIGFzIHNtYWxsIGFz
IDU0QiBpZiB5b3UgZGlzYWJsZSBhbGwgdGhlIG9wdGlvbiBoZWFkZXJzLg0KDQpZZXMgZm9yIHN1
cmUgPCA2MEIgRXRoZXJuZXQgcGF5bG9hZCBpcyB2ZXJ5IGNvbW1vbiB3aGljaCBpcyB1c3VhbGx5
IHBhZGRlZCBieSB0aGUgbmljIHR4Lg0KSSBhbSBmYW1pbGlhciB3aXRoIGl0LiA6KQ0KDQpJIG1p
c3NlZCB0aGUgcGFydCB0aGF0IHdoZW4gdmlydGlvIGlzIHN3IGVtdWxhdGVkLCB0aGUgdHggc2hv
cnQgZnJhbWUobm90IHBhZGRlZCBieSBzdGFjaykgbmV2ZXIgbGVmdCB0aGUgc3cgc3RhY2suDQoo
bmV2ZXIgc2VudCB0byB0aGUgaHcgbmljKS4NCkhlbmNlLCBpdCB3YXMgbmV2ZXIgcGFkZGVkLCBh
bmQgaXQgd2FzIGxvb3BlZCBiYWNrLg0KVGhpcyB3aWxsIHJlYWNoIGFzIHNob3J0IGZyYW1lIHRv
IHZpcnRpbyBkcml2ZXIuDQoNClNvIHllcywgdGhpcyBwYXRjaCBicmVha3MgaXQuIEkgd2lsbCBk
cm9wIHRoaXMgcGF0Y2guDQpUaGFua3MgQWxleGFuZGVyIGZvciB0aGUgY2F0Y2guDQo=
