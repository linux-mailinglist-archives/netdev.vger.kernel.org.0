Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C57319102
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 18:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhBKR12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 12:27:28 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8018 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhBKRZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 12:25:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6025683f0000>; Thu, 11 Feb 2021 09:24:16 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 17:24:15 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 17:24:13 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.50) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 17:24:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAWbyJW+l57dH4l2jYu0UmRs8/OnO1iTJQb1wEHzBSBkQxT0ZRBKuKLSsztjgzFn14GVBSov6PB2dkwqQiVFm28/TkcNVgJ7dKGbJXkaS2d+kWgzNk4oqs1wyhIvG70fKhnpuHdGid9NDk/nAizfa37K51C/MXVQOXL7yRdxPbbV5VxVehcpxUcwk12RbiXZx0AyM6jOZGAqJIx8K6xdcB/pzW28N9RI9a9+nRJLUuiBX0SkiAPOBpYzUUz9bjCBpyAtoAwx3v2epQKRXATVsTQ5m3BnHUnFJ4OSuOhS9XWYeu5QuxYd8Auak9Sg6bI3Tg8u4Oh+rWtHzL4PGHCL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOctTVjLWOwkFAl/R2WoPaQs7ZW5/7J4fFxNmCsGaPs=;
 b=Xxu7TqxIhDm/RS/4fLsGVVO5sxszANrL5xrl5jUquSnNWkxemIwOnvMxCYJIcObqybkXKsY7ztvkje+LvQm2laLjHWyNT65FpYgxFxr2GyK/FB5iC5XDhtj3v0LuBDZELHa4aClsoVBs7lfD8uGhFV3vTFOtS+ptED1k+IlaX2Zs7kA1PCgBklBhf4VHm7D7tvtYJT1cJPVAyuJANKaeZaLAownAHSV0ZPxJF2Bwt3zGyxQgCnhFCchE7a34tzue5hF+LLOQrePG60CxyVngBI76lP48UJLR/gwnmiusOUSe0aiy5HJ/3JrXiuqFPKMUfcBJcLrD2oGY0pD9+1NiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4114.namprd12.prod.outlook.com (2603:10b6:a03:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Thu, 11 Feb
 2021 17:24:11 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3846.027; Thu, 11 Feb 2021
 17:24:11 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH iproute2-next v5 0/5] Add vdpa device management tool
Thread-Topic: [PATCH iproute2-next v5 0/5] Add vdpa device management tool
Thread-Index: AQHW/9t3eDhjceI0nUqk+vH20hiwsqpTI9QAgAARoxA=
Date:   Thu, 11 Feb 2021 17:24:11 +0000
Message-ID: <BY5PR12MB4322DEAF77F8614A1FB9F6B2DC8C9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210210183445.1009795-1-parav@nvidia.com>
 <f5748e77-0004-4452-c413-15272a594d76@gmail.com>
In-Reply-To: <f5748e77-0004-4452-c413-15272a594d76@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 380c4e63-a3a0-4d90-de93-08d8ceb1d8a7
x-ms-traffictypediagnostic: BY5PR12MB4114:
x-microsoft-antispam-prvs: <BY5PR12MB411421D7FA0B0D3FCC47B721DC8C9@BY5PR12MB4114.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9h9ayVzv77DEaotItczZswguHBAsEOmKLrAmVEEaJXPWQQsgp0w2yheO42bthk6ImPCTHZW4qaWPGOp58qsrxOqHrwwqZWSWR/NEmpEV1qx27kv6KPHsswgnzJf1RHjrjZl6MQjur4argWgosGY1qsDaaJYHkAcQ5m2nQw9lEemxNRKIrJq237RmRmC2mB2LJA17W6Sy7DfNfElqBuuscBxiZHPSeecs57BpVHVDkPlAkvwhftL1EsOG8tXA3ANZmGyVbpCPUzayvhYAF39ogY7ikkIoK4Dp2YNegLbfNKFhZojdZnvXhUul+2qgKiaiFiKbAXgoQQildS48Fwiodq/Osf2tc8HUEhWY/SBJ7HWmN/eyvXM6J2rFgnOv8tYoylVJ1IdmIIMpuwvYZa1ak9JUTMScTXhbEGbIJnIPXh8wI2ZpMU9srRqceQcq+oDZVPjs3KvzjnOzENn0IDpthMNCgJB2akVXCGkUyRWMFiz969tI6DC71EBTWieTHcDtUuRRRIrLSdKDWtMFQF4AaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(5660300002)(478600001)(71200400001)(33656002)(66946007)(53546011)(6506007)(76116006)(66446008)(66556008)(64756008)(66476007)(186003)(4744005)(26005)(7696005)(52536014)(8936002)(55016002)(110136005)(2906002)(86362001)(316002)(8676002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RnBOUTdFdnV3Y1NCQkd4eW55QVJFbmFuM3ora0dDQUt0OWRLcWVmeWorYjBv?=
 =?utf-8?B?L2hoTnNBUDJCS2tIa1p0a3ZCdmdFbVE5c1UxRDNlTDZ5MTFFU29JVUxTdmdM?=
 =?utf-8?B?QWZZaVdXazNKQWZ0ZFRxMTJVSjhjL3M2cG5VQXNDNHJUS1NkeHFaY0l3dnha?=
 =?utf-8?B?Sm5vUFFxRmNPNG8xMjJKSEhiOTVGQ3VaWmdmOFVsYnJKZFBqL05ZdnRFQWhp?=
 =?utf-8?B?QiswUGFCTDRsc1Vmc04rMWVXQ1JMS05HLzJGMXp6SndKalZpb2hhRG5Ba0oz?=
 =?utf-8?B?bVh0ZGtiOVU5M091ZHYrMUpJMzE3TzJwQy9saVBsNXJEcWtIc2UwSEF2YkNo?=
 =?utf-8?B?TURQb1lvUkE0RTdvWE9qc3VFVEJXRVdGelBnRDYvVlJyQ25OL3YrNWdOaTRy?=
 =?utf-8?B?V1lHVlJJRHUrZEdSMHEydFBoTmJXS2VLUGZCZkx0V21wM1hqL3RDTlpaVUdt?=
 =?utf-8?B?L3RUamxoUXRBbEZOYmc1cHNnSEJPQzBRa0Z3aDRHWlFybmM5N29HUTkwK0R1?=
 =?utf-8?B?TWtuV25XV1lSaGJnMWhadE5xVndVNCtMakFrSXZUKzJOVnNzZUJoMDFxeGZp?=
 =?utf-8?B?SjN5YXl3YWFKczhtRkMxdjFlYTlmTHNlTEwxMXozZ2t5blN6c0IzN0xtYmZx?=
 =?utf-8?B?M3FOL3RMYVUrMW1zNy9MWVhlQU5EWW04c3V6Z0Nrd3hPOVdhVzd2RmdjRk12?=
 =?utf-8?B?SDZncGVYZGJxOVJRN1BJQytBM1NtZm9IQTZWOFYzMlArOGtlbzNhNTdPQmkv?=
 =?utf-8?B?bEpNMk5KM3hjelVHV2UxbmFqeEpGT2RlL0RxUWJqRlUrWW8vUEZOK0d2U3JE?=
 =?utf-8?B?NVdZT0dNcGNZMTFVamV0MVk0Y3Q2RFl2SGVTRndIN0NZNVJlZlpHWWxmRm15?=
 =?utf-8?B?eWlLKzVxTm9vaDdUN2FPN0Y1OGlidU44SDUyVE9MVnRSOFVUbWhGMm0wVWl1?=
 =?utf-8?B?ekN6ZnRmS2dsUi9XWHhMalFiTmE5cGs4WG0zYmFtYW4xVHhlOXp4TW1QSEZP?=
 =?utf-8?B?Mnc4cVZwZkZxNnpyVTdGa2tQTk1KTnI4aEl2NkpoT1NwQ2xySTVla0h0UEp4?=
 =?utf-8?B?dUFTWlhTcWdIUGExaGdGRXRPTm91STBTTkZaNTIzOUlwOXRPVFJFU0NtN0Uv?=
 =?utf-8?B?cEdhZytCZ3ExOUhlNWRhdE10NTVQTDhzMU1JODUvaEh0SFR4UVpqZm1WWlEy?=
 =?utf-8?B?NGNSQ0t0MW1MQS9NdjFZSi9pK0xXditVTHdXdC95NGhJWG52RlRyQ0V2NHFR?=
 =?utf-8?B?Rm9pZzg1NzZ1dWdtZlVybDl4N2dOYk51UnNzS00xMkc1WEVDeXoxSXVGV3Nv?=
 =?utf-8?B?ekg5bEpDckl4bWFJNVZ5QXArVW1pSXhYbDlUYVhRYWI1WS8wcml3aHJKdlJv?=
 =?utf-8?B?QjdxMndmTzZZYVlGSlJqak82V1luM1pWR2NleHExMHFpMW8zYitZTTFobGUr?=
 =?utf-8?B?VGQzOGlWYTlpYkZjT2tOK0hJOXYxRTlTbXZmekJOUEhpMk9icWgvNGFSOVAv?=
 =?utf-8?B?NmQxVnZKOHZxb3N4TmFIaHQxY1VLVUhiM1UzQThKdG9EQXpZUjVjTjBWRUVH?=
 =?utf-8?B?UzRWdVdxdXFvVjhzOGgzRlJwMWRERDJpdTd1cUlTZTliSE95NGVlQjcrQy9I?=
 =?utf-8?B?R0JaTGVWL1FCUVdZZ1dXUXdWVzlJTzFKVVNucGhTNkRCVTFxV2x2SkNvblY1?=
 =?utf-8?B?UWMyRnVRVVI2TW56ZDdhb2ljTW1SVHJxV0VMZlVSa2lPbHRvVVNhVjlEbnZB?=
 =?utf-8?Q?006G5NEIs7anvsmVEDVl2CZ7cd2BLf/Rgo9OANv?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 380c4e63-a3a0-4d90-de93-08d8ceb1d8a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 17:24:11.0954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qyVTL4FdEI9D0euDmspueTlv3KnrCjOe9a6BV10hUImstzuG0/GfwOQf0eI5Ve9guiR96WH0a0duWzKiaNSU5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4114
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613064256; bh=lOctTVjLWOwkFAl/R2WoPaQs7ZW5/7J4fFxNmCsGaPs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:x-header:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=ccg/BoydQ8IL+2fnbSyAcQL73DGMBfOYnWgAYIey+/9Xdg/1pQC5daRHNpaYzJcDh
         TpBZTwtjArNj5Gwhh3IZoUZ7cZmXMBwETpmfKF6KDFBx54Nqd936/cdryptiLLGp47
         Ja2FKalRJvPwEs7KrhtDhThGM4C3n+Veya4nfyhmBtq6Mn31DaUco5YBnbmQwo5CmF
         f0MgwtXkkY9njV/OAD8tYwFk7yzNizvrSMjfmCvEYvQr6UnkOhJoo4VoYc1sRUsucZ
         4s7ZAcB2XVg5Gpk14KUwGNqToFJ7C1lwTy0DljD63tvnnxDjKPN2aOU9tLvgKpGHGJ
         ayc0shgI3kc5w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgRmVicnVhcnkgMTEsIDIwMjEgOTo1MCBQTQ0KPiANCj4gT24gMi8xMC8yMSAxMTozNCBB
TSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+IExpbnV4IHZkcGEgaW50ZXJmYWNlIGFsbG93cyB2
ZHBhIGRldmljZSBtYW5hZ2VtZW50IGZ1bmN0aW9uYWxpdHkuDQo+ID4gVGhpcyBpbmNsdWRlcyBh
ZGRpbmcsIHJlbW92aW5nLCBxdWVyeWluZyB2ZHBhIGRldmljZXMuDQo+ID4NCj4gPiB2ZHBhIGlu
dGVyZmFjZSBhbHNvIGluY2x1ZGVzIHNob3dpbmcgc3VwcG9ydGVkIG1hbmFnZW1lbnQgZGV2aWNl
cw0KPiA+IHdoaWNoIHN1cHBvcnQgc3VjaCBvcGVyYXRpb25zLg0KPiA+DQo+ID4gVGhpcyBwYXRj
aHNldCBpbmNsdWRlcyBrZXJuZWwgdWFwaSBoZWFkZXJzIGFuZCBhIHZkcGEgdG9vbC4NCj4gPg0K
PiANCj4gYXBwbGllZCB0byBpcHJvdXRlMi1uZXh0Lg0KPiANCj4gSSBhbSBleHBlY3RpbmcgYSBm
b2xsb3d1cCBjb252ZXJ0aW5nIGRldmxpbmsgdG8gdXNlIHRoZSBpbmRlbnQgYW5kIG1ubA0KPiBo
ZWxwZXJzLg0KWWVzLiBUaGFua3MgRGF2aWQuIA0KSSB3aWxsIGZpbmlzaCBpbnRlcm5hbCByZXZp
ZXcgbmV4dCB3ZWVrIGFuZCBtb3JlIHRlc3QgdG8gYnJpbmcgaGVyZS4NCg==
