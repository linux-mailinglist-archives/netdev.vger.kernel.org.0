Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09DF287B87
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgJHSRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 14:17:47 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:43408 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgJHSRr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 14:17:47 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7f57c70000>; Fri, 09 Oct 2020 02:17:43 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 18:17:39 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.59) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 18:17:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQ1uJkfgsZjyxLssRkVjM1U9kD9d4vvIQlngWZIbcUHvPexEJA/yY3KQwQhZkSaPAHSTtxaPduf8xeP1j+Sauab6FuLK2o0K0RP0TBtBTz4wSVT//V9IJ3rPivg/oi5HKgqlAc1Vzi2UmDsuxJ8mKC3WBsaP462o3T4quedl4w8d70wHpU1CIjbiBWKDPJVsY/9g8fz4NCDvqYFMsO2/LlcLxQBLl2cXc6bjdkuZz0AsrwKBQEDZu/4T7yTB1c5N58MWAMQgY6bTVAXO3M10biLilnQL0q50f+4Cxxa1+Ue6D9ak0beQ33e+zHNW7ZC98e4Yqy5g1OTS6iuqQVCsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVgLo7LVi5wG22BE2M8MjDj1X+fU1QGqle0X/Ik+/Jk=;
 b=mgPGi+/UwlmKNva7f97m9CaQ2djLtV4gwZAOHVOwYdFSoUfSMptDT/Jn0szQkZcJuXwJQTeYMSdoD33t/wS7jbPdN0wxUnLqxKSXs7DM+MjJ5kHWq4yUfJ9HEx/W07pstiylHLmZybSX2zzzabFTUH7gNfaTGGgZZfxxpoKwWGh5YMlUFLOazbHRSBv7NWDMnepdfNk0yva2DXcMRa/CSFdK+6lDABljAS0pbqATmRkpsoH/uryyqIrZfmnpxlcoD6R2nn7F/RMapA8ChIuNBSFdzqpUG31WfiJLafjA+BYM6fZoGKLzUsDHQGY0YhljXmss8DWBGSNdCCN9YEctZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from MN2PR12MB4286.namprd12.prod.outlook.com (2603:10b6:208:199::22)
 by MN2PR12MB4286.namprd12.prod.outlook.com (2603:10b6:208:199::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 18:17:36 +0000
Received: from MN2PR12MB4286.namprd12.prod.outlook.com
 ([fe80::61fd:a36e:cf4f:2d3f]) by MN2PR12MB4286.namprd12.prod.outlook.com
 ([fe80::61fd:a36e:cf4f:2d3f%9]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 18:17:36 +0000
From:   Donald Sharp <sharpd@nvidia.com>
To:     Dmitry Yakunin <zeil@yandex-team.ru>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] lib: ignore invalid mounts in cg_init_map
Thread-Topic: [PATCH iproute2] lib: ignore invalid mounts in cg_init_map
Thread-Index: AQHWnZz5hqQbNli1/0WDyf+wvKG72qmNwE+A
Date:   Thu, 8 Oct 2020 18:17:36 +0000
Message-ID: <C96FAC1B-B20E-48D5-843B-AF388346EAE9@nvidia.com>
References: <20201008175927.47130-1-zeil@yandex-team.ru>
In-Reply-To: <20201008175927.47130-1-zeil@yandex-team.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: yandex-team.ru; dkim=none (message not signed)
 header.d=none;yandex-team.ru; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [2606:a000:111d:823e:f9ae:5d86:ae57:a3a9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6b05ee9-b887-4c14-9482-08d86bb66f24
x-ms-traffictypediagnostic: MN2PR12MB4286:
x-microsoft-antispam-prvs: <MN2PR12MB428633522385897E09CD6366B40B0@MN2PR12MB4286.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YrSSgACiL/+tsQ6W5xIMr8OOtAvNTBXDsD29JLe7kE9ojlgZJEeVXmH9fO+qitvceq1UgMoYwEjHv31rX32DSt8COVArr9E8hLK7G/bnUB99iPGopRLljJD6pmIFpVZVk9I5bS7mv857sTTnX9GgmFc5cCGSSE7iwR2aF/KnEkDY/Pp5HjeMJWhCd4hWFHz97RldOLkuq9GBkDWZmzDUTToae++pbEVppNKHwOEMP9wdW04KqaeqHzqk2q9AGgHHbhZDbK6kwlNoU4AeK3NZK7sT9c7ewptCGuGeRFdsr5fcbiqgJYBwkdopaaVfqPix
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4286.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(8676002)(36756003)(2906002)(2616005)(4744005)(33656002)(186003)(83380400001)(6506007)(110136005)(91956017)(66946007)(71200400001)(66556008)(66446008)(316002)(66476007)(8936002)(6512007)(478600001)(5660300002)(64756008)(6486002)(86362001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: D9vS969jI4Upjbf++86XZTxeL+8M5DBJSisDBPVg3pJrK0rhqpWxMfHKfDvXspeWHSdG5w9SvjugDTGbNR5wpnVdWUf2HmJdxTgZzOvMzerQufvP+qh6JBusxGGuqUZEmDpDxG2KCkzgNYlOwXiYRaNa0VlDb23gmaMsTo6Btqp28adgjCzJAjc6tJDx9gUN2gK9W3Rjpowi83YOVjD3uRRJt9PK3WQ2+32f5nhujCErpXhvVhtNztJ4DQxyUFEuNPTYUCs8AoEkaVYUZtU8Akbkc662J6H3xeG+t9X0zjMdt2iz4yHj5K8iR2EwNzunMEttVw/TPoJell2BrE75TShxjPKVOkrQJTRTtaYQUCHYdBUG8RZce3q2+Ie4elwAH2E9keYwCoHNY5SzlM2rCt1b9C0wnhvWeKMZvbDsT3YDEhTgwUbThQ4nXkR+HxZwESnzV3yU/iMSwGugp8o6kRm6t3RnH4eZOTKS8YaY1P2Vr4U6S6dJrg1Zv6LWxjJWe1GSUKO4lST+BVAvlSMgET3ecAUYz/eOCB4G9OtUTQXy0dvqDBurhN0qxw1eBW39Gkj0PgQifU6Ff0HVIqjW7NPkaaPOo8FwY0XwysBnDuKjeiYFS3FvqxBVkKtgUWrbo5vSA9nRZt3vxgOu/OVA6yxkjThS+8rhU7ebj/RAhocJ8HWLrnSgNFz68Q8EgMs0YQsnMjer9nYCCnfBv1PnKQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <79A6ED6427794042B5B3B7338F976059@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4286.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b05ee9-b887-4c14-9482-08d86bb66f24
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 18:17:36.4668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zhgNyqR5j3Iz3DCFOuo5HFHOlUNqFTeGv+04znJ2IzbTarYZpqIWPnCuwh0YTKbuj753sMO70pJbAajJMLlQrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4286
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602181063; bh=GVgLo7LVi5wG22BE2M8MjDj1X+fU1QGqle0X/Ik+/Jk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=qPHpyKRoBcw4cgluVrZWW/LZgi9shSeTWo1/2oUCC+N2BnFiDt6bDEfOmIEXnENzt
         u5k4r1WQiLQBhaZsYiA+jhGoJZ3Ep5Wgn0+Z1Hi8Kwvo+/Qdm35NuwsmqWEdyQOIEq
         6eKRX0yGdvI/yaqO34VTsdx1cVxipTqwE3UpvIB8TMsvvW42LzPnHf+v933Vt+BUfZ
         mQjgKbI1eTOM0oFd9iqaRHiz+JFgoYOpIbsyrdwPobrBzNdkUgdFqqKpqBgD2NAuXO
         nfvUlGsJKfEge+H+ieP8bK8Flf3MQSeb+WMyzKhVAtjsHUinnHzk+7irV5t9WUI1e/
         p0DzfzbNfa++A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSd2ZSB0ZXN0ZWQgdGhpcyBwYXRjaCBhbmQgaXQgd29ya3MgZm9yIG1lLg0KDQpkb25hbGQNCg0K
77u/T24gMTAvOC8yMCwgMjowMCBQTSwgIkRtaXRyeSBZYWt1bmluIiA8emVpbEB5YW5kZXgtdGVh
bS5ydT4gd3JvdGU6DQoNCiAgICBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBs
aW5rcyBvciBhdHRhY2htZW50cw0KDQoNCiAgICBJbiBjYXNlIG9mIGJhZCBlbnRyaWVzIGluIC9w
cm9jL21vdW50cyBqdXN0IHNraXAgY2dyb3VwIGNhY2hlIGluaXRpYWxpemF0aW9uLg0KICAgIENn
cm91cHMgaW4gb3V0cHV0IHdpbGwgYmUgc2hvd24gYXMgInVucmVhY2hhYmxlOmNncm91cF9pZCIu
DQoNCiAgICBGaXhlczogZDVlNmVlMGRhYzY0ICgic3M6IGludHJvZHVjZSBjZ3JvdXAyIGNhY2hl
IGFuZCBoZWxwZXIgZnVuY3Rpb25zIikNCiAgICBTaWduZWQtb2ZmLWJ5OiBEbWl0cnkgWWFrdW5p
biA8emVpbEB5YW5kZXgtdGVhbS5ydT4NCiAgICBSZXBvcnRlZC1ieTogRG9uYWxkIFNoYXJwIDxz
aGFycGRAbnZpZGlhLmNvbT4NCiAgICAtLS0NCiAgICAgbGliL2NnX21hcC5jIHwgNSArKy0tLQ0K
ICAgICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQog
ICAgZGlmZiAtLWdpdCBhL2xpYi9jZ19tYXAuYyBiL2xpYi9jZ19tYXAuYw0KICAgIGluZGV4IDc3
ZjAzMGUuLjM5ZjI0NGQgMTAwNjQ0DQogICAgLS0tIGEvbGliL2NnX21hcC5jDQogICAgKysrIGIv
bGliL2NnX21hcC5jDQogICAgQEAgLTk2LDExICs5NiwxMCBAQCBzdGF0aWMgdm9pZCBjZ19pbml0
X21hcCh2b2lkKQ0KDQogICAgICAgICAgICBtbnQgPSBmaW5kX2Nncm91cDJfbW91bnQoZmFsc2Up
Ow0KICAgICAgICAgICAgaWYgKCFtbnQpDQogICAgLSAgICAgICAgICAgICAgIGV4aXQoMSk7DQog
ICAgKyAgICAgICAgICAgICAgIHJldHVybjsNCg0KICAgICAgICAgICAgbW50bGVuID0gc3RybGVu
KG1udCk7DQogICAgLSAgICAgICBpZiAobmZ0dyhtbnQsIG5mdHdfZm4sIDEwMjQsIEZUV19NT1VO
VCkgPCAwKQ0KICAgIC0gICAgICAgICAgICAgICBleGl0KDEpOw0KICAgICsgICAgICAgKHZvaWQp
IG5mdHcobW50LCBuZnR3X2ZuLCAxMDI0LCBGVFdfTU9VTlQpOw0KDQogICAgICAgICAgICBmcmVl
KG1udCk7DQogICAgIH0NCiAgICAtLQ0KICAgIDIuNy40DQoNCg0K
