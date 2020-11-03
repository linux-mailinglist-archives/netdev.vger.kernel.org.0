Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3054D2A4B5B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgKCQ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:26:31 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:22047 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbgKCQ0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 11:26:30 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa184b50000>; Wed, 04 Nov 2020 00:26:29 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 16:26:29 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 3 Nov 2020 16:26:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPDFVR1c41RSTJb4p9Im6hEFjb3QFOYbPbmMsQHgAAmwMjA2TjQjSI0ytEDziPxgf6Vdm/yDfoohV4ohux422i2PfLrydbhBrIBQBpNJk6Xacs5N4qDlBVJvppHz7nLOjpLIfi1DC1l63wnI9/ikD2hQG3pPlYEucNupCggp4lQws480gl/KEHnzC1FW5hZDqENTk4rKWAiqPVnkbfUGBeHvgEwWLAu3yr7a8RO4ddFdNOoGfsaYaKVjKIoaHHdGrJuKHIJRip8fIDYGtW4I3PvV5Y0CgbWzMfFatoUY2T02594W3X8ZpXZyurJznib59n6gRwNsOnWZac28WmeEug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1tATsxgREHFZSoWYxz7YKJIHFSOswzbNqM3WpL7Fok=;
 b=XuAvpwpCIAY2KqApdJWYa+gtZCeuBy371d/uYvDsyrezFiTo8W283XKdiCZrX6TBp042A8bSWK09tm1MtFJFqtFiT3f/+MwDSFoS/6mZPrUiX2lMaUuxk6XgkJ9VfXWzRve2cP1+Oycz8BoabyJBKuJQGkmIB/ewHeoUsh2LxMzLy+6QG3iuORUiGQVmeMFPfureTYkikD0j7Not9jMFEJiF19y3bquLSjzHomGGj72TqleNXRx5WxEDtkw7yo7D33tRyAVURUv3nULSxkxG5CRifz+OJ98w7FIlp+fqZlpDPFLMLXJggs9NMc1DKEtn1lb1x6Cb4kXv08+riHCJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) by
 DM5PR1201MB2488.namprd12.prod.outlook.com (2603:10b6:3:e1::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Tue, 3 Nov 2020 16:26:26 +0000
Received: from DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::a164:31dd:cebe:4d49]) by DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::a164:31dd:cebe:4d49%12]) with mapi id 15.20.3499.029; Tue, 3 Nov 2020
 16:26:26 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: disable multicast while delete bridge
Thread-Topic: [PATCH] net: bridge: disable multicast while delete bridge
Thread-Index: AQHWsSXrHRI1tvW7iUS7+/80e/6fF6m2mdgA
Date:   Tue, 3 Nov 2020 16:26:25 +0000
Message-ID: <067c94269abed15f777ac078a216be314c935fd5.camel@nvidia.com>
References: <20201102143828.5286-1-menglong8.dong@gmail.com>
In-Reply-To: <20201102143828.5286-1-menglong8.dong@gmail.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3653253-377b-4282-0dcb-08d880153603
x-ms-traffictypediagnostic: DM5PR1201MB2488:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB2488351A3A379C4DE106B698DF110@DM5PR1201MB2488.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D9a/ktX2cIqRbf1XGWB0Vqbq8ml1INh1Q4vaNDY2v3ufZEdVJm+P4ibII6moX1/BS3z0xPi15IH6aOpSXtcGsSsqGn7at1mOZae2AfBW/+ZHoLxZAtiKIAzFdxLDPYmPpfuufPGcPZM6hkxv9ieT0qZ3nik0d2qwXDrOsZn8Wxgnty1FZMc50Wj0GmYKDdkiCHYauksg0LWkTYPqV1UfDHeStlmcms/ft/F4WUXXnTBuCr84Z6V3CuMYXHxiNnRWLrU3BFv2D3Btj05avUVcLeMBo1EwUgovkYr9ac3ZDRNcJ5MNHYzYSJx3TSp40TbQNswa85N3mir81nMespEYnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(54906003)(316002)(110136005)(2906002)(478600001)(36756003)(26005)(5660300002)(186003)(71200400001)(2616005)(4326008)(3450700001)(6636002)(83380400001)(76116006)(6512007)(91956017)(66446008)(64756008)(66556008)(66946007)(8936002)(86362001)(66476007)(8676002)(6486002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: oQczqZM6P9n53wO8+kALGlOXPCk63ZGECA3t02Rid4AOQNzOS/AnmVl1FkEq//anMtuI1qO9y5eUIuc7e0lNXtidGQHc6mjHB24mo+P64za3rxiplP7H0h03W/Q+7iglpLY5jCuJDIB6FKNikrPsrdDTU2FZMmTiMi5O6P6wcQGeDHx3zdCpq2JgKa31UI2utkcLW7gEBtH8ZjP3F7w3DqaaPL8c0EfDYxB7cWfCdsLjJIHkb603sNI0+AvH5oyaqXnj21NNswEgUywnwcUzr9tSKFe9hpmnkUsn0rpwaXueReq4LkidSbFyiC4OcZvThqBx/ylQCzXcCtFkchsm5Z9nueCg59TnMQsOtIEMfDTH73OAQPfPT69Hl7SPnoe7EKIIteBU18iJp51mdftiEGv+PfkdOgsiFs46AM/eQ+TSDc8h0+4iPLn9X/riLodi2YanzRvIHsyga1IXW2jqUaUB5LPudUGdDkNbwrBO4XnmQhb0VkbiHHu40U0CCuHsH6bMRG8Z+kidFzM4K30wyB4R6P7OWPGSQxYuXN9sgRk5fSao4l7x9/uPvO8I5aC/i60Vecaa/C/IsGoOjrTzBaDbW1tVUeuOYM9PuvZCO3G05aSEwSud21k454cPTZKhEauKxkTcdylhGIxVzjYFzg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <680D0BE04AACBD4292520B4598C416B7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3653253-377b-4282-0dcb-08d880153603
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 16:26:26.0384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gp1RErNGirDjAl5U9+j77dj2QAlklUHSVd1F1yZWPEmZB8/p62EB2/riNfcY9BVdUe+7ErHolsicgbyI8ilpZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2488
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604420789; bh=e1tATsxgREHFZSoWYxz7YKJIHFSOswzbNqM3WpL7Fok=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
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
        b=T9fiDLVXHn+bSQ3JVHTmryS/wfQgRS0ZUDK94dzm46ygJIRNqh7l/FcOLuCQYtTq2
         PEuPkXTA4nucld7raOuMzpLS/afdanfTcgPSKwjm1OhdhptAONYlFWbnIGMILrvCZP
         EgpWD1wbLT754vuZd6iasLFx0xZhzaIJdTGUHhQ0JfqP64RL19a+SV16F6UVazzvyr
         EWcF4+VZuwVNLZ59U9FZtsxC9Wn0gKKILpzw+0VZ/LJio1FokANeUHOSV39/VDojj4
         MOII4K9/zOjX+VQWVwNlYYKKmqsSXojPqo7cn+0u4ZbV/3AQWMb8pyCbcgS7rc15Sj
         MCGP6mzSZg0Yw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTExLTAyIGF0IDIyOjM4ICswODAwLCBNZW5nbG9uZyBEb25nIHdyb3RlOg0K
PiBGcm9tOiBNZW5nbG9uZyBEb25nIDxkb25nLm1lbmdsb25nQHp0ZS5jb20uY24+DQo+IA0KPiBU
aGlzIGNvbW1pdCBzZWVtcyBtYWtlIG5vIHNlbnNlLCBhcyBicmlkZ2UgaXMgZGVzdHJveWVkIHdo
ZW4NCj4gYnJfbXVsdGljYXN0X2Rldl9kZWwgaXMgY2FsbGVkLg0KPiANCj4gSW4gY29tbWl0IGIx
YjlkMzY2MDI4Zg0KPiAoImJyaWRnZTogbW92ZSBicmlkZ2UgbXVsdGljYXN0IGNsZWFudXAgdG8g
bmRvX3VuaW5pdCIpLCBYaW4gTG9uZw0KPiBmaXhlZCB0aGUgdXNlLWFmdGVyLWZyZWUgcGFuaWMg
aW4gYnJfbXVsdGljYXN0X2dyb3VwX2V4cGlyZWQgYnkNCj4gbW92aW5nIGJyX211bHRpY2FzdF9k
ZXZfZGVsIHRvIG5kb191bmluaXQuIEhvd2V2ZXIsIHRoYXQgcGF0Y2ggaXMNCj4gbm90IGFwcGxp
ZWQgdG8gNC40LlgsIGFuZCB0aGUgYnVnIGV4aXN0cy4NCj4gDQo+IEZpeCB0aGF0IGJ1ZyBieSBk
aXNhYmxpbmcgbXVsdGljYXN0IGluIGJyX211bHRpY2FzdF9kZXZfZGVsIGZvcg0KPiA0LjQuWCwg
YW5kIHRoZXJlIGlzIG5vIGhhcm0gZm9yIG90aGVyIGJyYW5jaGVzLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogTWVuZ2xvbmcgRG9uZyA8ZG9uZy5tZW5nbG9uZ0B6dGUuY29tLmNuPg0KPiAtLS0NCj4g
IG5ldC9icmlkZ2UvYnJfbXVsdGljYXN0LmMgfCAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9icmlkZ2UvYnJfbXVsdGljYXN0LmMg
Yi9uZXQvYnJpZGdlL2JyX211bHRpY2FzdC5jDQo+IGluZGV4IGVhZTg5OGMzY2ZmNy4uOTk5MmZk
ZmYyOTUxIDEwMDY0NA0KPiAtLS0gYS9uZXQvYnJpZGdlL2JyX211bHRpY2FzdC5jDQo+ICsrKyBi
L25ldC9icmlkZ2UvYnJfbXVsdGljYXN0LmMNCj4gQEAgLTMzNjksNiArMzM2OSw3IEBAIHZvaWQg
YnJfbXVsdGljYXN0X2Rldl9kZWwoc3RydWN0IG5ldF9icmlkZ2UgKmJyKQ0KPiAgCWhsaXN0X2Zv
cl9lYWNoX2VudHJ5X3NhZmUobXAsIHRtcCwgJmJyLT5tZGJfbGlzdCwgbWRiX25vZGUpDQo+ICAJ
CWJyX211bHRpY2FzdF9kZWxfbWRiX2VudHJ5KG1wKTsNCj4gIAlobGlzdF9tb3ZlX2xpc3QoJmJy
LT5tY2FzdF9nY19saXN0LCAmZGVsZXRlZF9oZWFkKTsNCj4gKwlicl9vcHRfdG9nZ2xlKGJyLCBC
Uk9QVF9NVUxUSUNBU1RfRU5BQkxFRCwgZmFsc2UpOw0KPiAgCXNwaW5fdW5sb2NrX2JoKCZici0+
bXVsdGljYXN0X2xvY2spOw0KPiAgDQo+ICAJYnJfbXVsdGljYXN0X2djKCZkZWxldGVkX2hlYWQp
Ow0KDQpUaGlzIGRvZXNuJ3QgbWFrZSBhbnkgc2Vuc2UuIEl0IGRvZXNuJ3QgZml4IGFueXRoaW5n
Lg0KSWYgNC40IGhhcyBhIHByb2JsZW0gdGhlbiB0aGUgcmVsZXZhbnQgcGF0Y2hlcyBzaG91bGQg
Z2V0IGJhY2twb3J0ZWQgdG8gaXQuDQpXZSBkb24ndCBhZGQgcmFuZG9tIGNoYW5nZXMgdG8gZml4
IG9sZGVyIHJlbGVhc2VzLg0KDQpDaGVlcnMsDQogTmlrDQoNCk5hY2tlZC1ieTogTmlrb2xheSBB
bGVrc2FuZHJvdiA8bmlrb2xheUBudmlkaWEuY29tPg0K
