Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEFB289B1C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391866AbgJIVlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:41:14 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12778 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391853AbgJIVlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:41:14 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80d8c10000>; Fri, 09 Oct 2020 14:40:17 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:41:13 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:41:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjkUOmpiQJLGHW1281EOgkuDEafBRvNFsAx+brW45y0ENcadA5F0oNx2Zy+8dkCJ2AUHYQntzYAB7ZaWmaz1ucPHLsFPVLZdSmTnXWy8Ljk5jI5/oeJjDRCPxJB27CgN3AEZ8XLYcHyzTeXbK9HpmOoV1pjp9Qht5XQJKICDqwo6unkolQWwvYjmtQXiH9/8BRF07jgunNKZg8n6DA9PxlrIk4FRWOXfAYsCHIM7AYnsgR6YvUyywTbaD+zZ0vrinfP3DGC35tYOXyOuNOjerbR52r4wWp9e3YDBcprMCEvHpvghA0DBD6EvhJKbX3Gx/qmPQVHnkjkb9m0qzD2frw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynn4ygqhnj3RM4OdfcN8TkkP5pcf3H96UUTDqOs3FHE=;
 b=Co90TFZyL/sk6QJWUXp/1wDOtPZTlvjYbLYMxwURn5xgO80cPAqAxZSKdmorKpce4dyuSLS6SyCm4xyUBTNA5LDy78PKhFlzeJcwKY4vv7tliEosqFnNKXvmLHPeY+7Xm1C3CF+e5L3UqdnAlxTmRaBbh5bHA3DmQPnsbJkzT6L9tW9WQ2ruK0viCjF45z2C/7Y3dkz1sGm3zw7BZCWYqGCOxbge+XFM9l5WFakIorggKYYeRycm/oHn1lMyF967zx2pL0et6VgfZoBggkzCEpjCdfN2Zj6I/9qpiS6Bs+wItb2hjYCoyUDtZVhxmpzLEUb+OvZUdB8GfKdctYpjFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3897.namprd12.prod.outlook.com (2603:10b6:5:1ca::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Fri, 9 Oct
 2020 21:41:12 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:41:12 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 03/10] bridge: uapi: cfm: Added EtherType used
 by the CFM protocol.
Thread-Topic: [PATCH net-next v4 03/10] bridge: uapi: cfm: Added EtherType
 used by the CFM protocol.
Thread-Index: AQHWnknTeVdVrUrdWkKdBhAkeRzxJamPzTuA
Date:   Fri, 9 Oct 2020 21:41:12 +0000
Message-ID: <eda6fb9c0535077be89d2ee7dd9f7e12f730ef68.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-4-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-4-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f84c1a9c-3165-4f66-e0e0-08d86c9c0ade
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3897F3E2D259F59EDBE4C6E7DF080@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f37RQ8nD0wBgacncLe2wCKQkrfioM/edc7/Xzm4Du8D4MgS6ZxHLbA1X5tC5M1DWirhjAGcyitFyQ5HWrkd2J6Wvod2LHhSGWvVN1vWvKWs8JL+CKPikgdKm3tYwsB5GeCqf7yZpMVznXAVO1ppPD8K9jrZKkXQhuBRsRK1j8FIL0OvyJGt7XOW8LTMB3Re+jRkVUeJMjdfvSonFBSoYm25SA1y9YQ+9SXir/8ny0CGIczcnCKLReal/5pc0wzl/fkGGgiyuYqNPU+qswiCmonliXGpgH4paX0ig5EyDFSmGBmTlsCB/8scnZq325iwolG7zL3jU3zEyKl+CWwLGk8AfP2m0pA3xIZrJbdwtpaw+7zulFWY0sn3J+RBts2XH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(478600001)(2906002)(66946007)(71200400001)(8676002)(8936002)(3450700001)(4744005)(316002)(5660300002)(4326008)(2616005)(110136005)(6512007)(36756003)(6486002)(66476007)(66556008)(186003)(91956017)(76116006)(64756008)(6506007)(86362001)(66446008)(26005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: R8NwERZirOgs5hA6H2vwjGkmjcQnwsxZv6xjFf5w/cR/pRbUskbjTLk3tOgGWrCqLIjrp6qicTFpFRrtKFX6lFOrGFyoCVi6mGCKQgM5Th5JpPwhLmLSahT6fvxVEKz9OndJkSiFFS5nVr0Ni9wS7ZwkGywEHI979FfEVH3BSKbn6K54jDZP8LruV3K0Mx80cqyvKqV3yL+4Q9zW1YYKeBvRvCwkEWMdHWoR4svlAeEBtyxZPEdyszR+UTzc+Pmh4KxPaHzmW78IJnRnbR13jHZnc3A9R8JVNosHgggD0UXPlUdVydM7pMvdE0Z2aoadGtZ1DcxboaKfcp99IASzVVx/RrEHgUBaIMu8ep7zpNDKSBSsxGrQj1KGKVR190gsRjBlCso7bpGqN7TwnCpZKqViB8j8QhHaAFW6xK8WL2J4Zm4GzjvK3OZ6vSKTl5gASng4m/pssPIarcqUJDjY8Ppz7vPU9JUePNeNhcC8r5PBUsLqxmq861JILzmmrEX020pZT1/Z4CarrLRqrSuMD/Dk1jbL/sZ+vssXAN90UEl+XO4tknaUv65pWEEM9dnstOsRuhNCD3Y/Y6aT6+rNld5uQ4czDPyLV6Jxzom0Zoo/tGEGh6aUiVlIuMWcQFGS3sB3F7TfpgOfIKL5FOUmcA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFFF9698345104489C95AC5C8AE91CE0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84c1a9c-3165-4f66-e0e0-08d86c9c0ade
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:41:12.4312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2o7/h7VpcJWkiOPZNFTUuj1uF/lKAexvpQcbwioW+jYOtSsRuTyTWFBsnwDdrOAYbpSx1DoW3FQ1iq28fLfXqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602279617; bh=ynn4ygqhnj3RM4OdfcN8TkkP5pcf3H96UUTDqOs3FHE=;
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
        b=Xk2hsGucu9i6QRS6V3MZ3mTJX/sUu0bFpiOnh72yQHFhuCDnG8h7rOlBzntwUl7rm
         PT7ex9AgJU4Q1YN9HEa3AIiHTY9x9RApsMRdr4x/3fihXKAec/gVJbfBld4YKdfsMR
         /zToWNy3rXTGVHAW6x0WC1Tb6aHpZ0BfnIDKRAiXN+EYONed59AkJAUcNh5pGk48Qf
         fYtRY/U2o5SPAH+0fyYeN0DFRAIIfvTeXhQq32OyoY4BZrNFcxAO2Q06OxZfzjxxUc
         NcJNaWm7jjs9aJjShniukzh5Lv8D6AcB+Q4DqoQHmhCCfQf7znTNKrmfF8ZfReIQTe
         ETD6FeYso5ysw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBFdGhlclR5cGUgaXMgdXNlZCBieSBhbGwgQ0ZNIHByb3RvY2FsIGZyYW1lcyB0
cmFuc21pdHRlZA0KPiBhY2NvcmRpbmcgdG8gODAyLjFRIHNlY3Rpb24gMTIuMTQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVuZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3Jv
Y2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhvcmF0aXUudnVsdHVy
QG1pY3JvY2hpcC5jb20+DQo+IEFja2VkLWJ5OiBOaWtvbGF5IEFsZWtzYW5kcm92IDxuaWtvbGF5
QG52aWRpYS5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L2lmX2V0aGVyLmggfCAx
ICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiANCg0KQWNrZWQtYnk6IE5p
a29sYXkgQWxla3NhbmRyb3YgPG5pa29sYXlAbnZpZGlhLmNvbT4NCg==
