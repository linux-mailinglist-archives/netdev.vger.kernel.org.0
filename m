Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC45289ADA
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389586AbgJIVkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:40:09 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:19493 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbgJIVkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 17:40:09 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80d8b50000>; Sat, 10 Oct 2020 05:40:05 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:40:05 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:40:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dN/oEtZ/0ZPx02tAaXYKZmTYx7Tlm6wLrFqPEiWI1Qx+cA2EfcF1Gy3aDerBaYOr73irDvoxMhnricbUd1gVhCFlDLvcFGpEWLGUbmnmKKW8HYHYH1v9KnkUHRJAeJUIyMB3c5kr8nMygmsVoQN5fR6NQxFehPLvpOeugkqPGeKI+J6uIkmVLaHiCgf5wCuursk4z2lQJOjRtBcIofya7Ria9ECyvmYzAAfXdVyhRu5AA8luoXZHkpmXVGA7pLbZ03DdQ7nLRx1VYHIKvxLRCS92RRCmCV6G3/5qJJK8rAfaxYpGBV8d1qu7OkToFD52p6VXoT8DfKnNbaWVH7FM4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvdfHE5n57eHvHQc7EMX0wX/IA5vR/jx6PS5SxBPbcM=;
 b=m7OOf1dbsnH/1131SJ6ExefNEkOSAPIdsOs1XxybYN69fgsxV4amFlhVTogCrdSDT6n6e65LUDzHQci58T9L7iX3y1WSJxlplVrJdZjbbyh7X5yBfkdGyhNNRGzG61ssUhluCWpvBBtUFJj3m7xR1H8H56L//mqBQNClZ1rlZ3zz2RlDR4516hFxdAa2qKnOXyAxD2xUoGB8C2wrkhvp2L5SaAQRP5Ej0j1453rPBgLzm1IgIkv2wZ6Q/uIwDJqxeisN4cR9cKzcez366Z/y/9opYvHFHK0/nycD8wYR3pmBLhBDMOk0ahlr/FYgDQ0KSUMCLF3dRHNVP+XJB7D8GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3897.namprd12.prod.outlook.com (2603:10b6:5:1ca::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Fri, 9 Oct
 2020 21:40:03 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:40:03 +0000
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
Subject: Re: [PATCH net-next v4 02/10] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Thread-Topic: [PATCH net-next v4 02/10] bridge: cfm: Add BRIDGE_CFM to
 Kconfig.
Thread-Index: AQHWnknUQ2L8lvyK7U2lstNK1vxWJKmPzOgA
Date:   Fri, 9 Oct 2020 21:40:02 +0000
Message-ID: <d614886f589e753c75bfd146da7a4ada98a84566.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-3-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-3-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 846af58c-c0a7-419d-52f5-08d86c9be17d
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB38977CEF62FC7B9DA54D8117DF080@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W8tceH5k8bxioadME7Z3wlCMNtJ6qJhMbq3NHDnQ0j7NsDKYYhu3K79gG7V1ov3vrvrC5FHVf8K7cDu4gnxznLE3eYV/w5Vxv6hZF0EGriMN95g3WgjgDIIPT+iOocX9pz3Jwe+GDiQHUBzKN+wp9sZy67KLD0yj6XC2hxTLGXRcDbzKol5esC38ThKyZZhMABXOQKOoAJkSVaPRpEydVKtzgA1rK9z2JISTa81+Y1NI4cEu75HwMrnVGl3l/8KfigD/QQYU7Gl6rZnCXXzLLA4QJ9LAG2s4HBEBdd5BKhzylyG0naWa7K4N7Ph2ZDWXfX2fx4BIlPKGGVTqcGZvESK9hBfbiH/fKlyosA3stnCgXKMqbnf6kpg1HKY5jv0L
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(478600001)(2906002)(66946007)(71200400001)(8676002)(8936002)(3450700001)(4744005)(316002)(5660300002)(4326008)(2616005)(110136005)(6512007)(36756003)(6486002)(66476007)(66556008)(186003)(91956017)(76116006)(64756008)(6506007)(86362001)(66446008)(26005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 9R7HQ5TeroVaYIAxhuL6IIkHzvj86wbB2/QV3Ynbja9k/jnmKEpBipMSgKE+RZbuP3QbGDjMAyzzB+ak3NXpQKiEOFHodI1XPB50sDdfZ1Qg6FX+ANB6ufnbiENCoM6r3fsLyvcgqnenkAkkGHkqfejIaiU6QtN+0LeuepfCdI0UaxofAV3uGtgS1rpHfZqmS1XYdBTJPwdZljf5CxDVxqyX6AYqNVENawC8UlNh3lBn5mWnU6pz37ibBVldEkMJPhTt/FuwiG+RYuvLWbSZLWWDu0BRSYB2AK/IKe4twbnrWF91J7qvykxDJrfjbsQ20pOAXNI6TSxQiQ9WYRs1hOUT+76SR6q2z4Agyk+/2ItX6/cRCryHfTYm5niTdYCJjhvhrP2HmOLDdgto4xCtvUIdEC40IaQR20cbr+xc318a6UzTdwQIpjbeiFKMBdznh7QGDIDqC5GncjbQflBaKHEe+hIz5eCSdi4k4qvj4Az9DgETjgXQYQaYRsVeLX8GDQ3aFFiCqLZQbIMOVjIEbCLMFe0QKCJpqwDKyynsBQlz6Pyg3lkjWwE0m1+Sq/vCFqKn56FErVXPWYmjI8/BIpTeBMUMcfX+CKjLvsMtERtOMRwV5Eyd0M/RECCDDisoSF8wMldY4ez0lPR7tXAlAg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D67016BA2D74E43B79EE0EF309148FF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 846af58c-c0a7-419d-52f5-08d86c9be17d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:40:02.9773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: InSVtnU4vac9z2x/QNW7rPQp5eat+E+3n5VGKwlCxSTw8GMdjQTO2m0zvjlIgj1IihjzPWHHWy1t4OifHaB1Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602279605; bh=MvdfHE5n57eHvHQc7EMX0wX/IA5vR/jx6PS5SxBPbcM=;
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
        b=QpeO5wUVqin9JvHvRfW6iwIlpoibaGocPCAN+AHKkZ8STIGki7LeAJM6m9TeTwTW2
         6OwYuPo3KY4IOuxtsBhJWTOuSo2r67KlljwqgjgQaaRET6MfHCi/KWLjGfardx3WYE
         H2DuR7y2zTM1fKkyNnCgFH3lhjRG5JTzOFUVFGvUtl0JTyylXINVdTGTqeZSocdJqG
         QH1XYGo4yY6+lDVfY5OE1rm+f0Q1+7n2g9+G4oqQiSqB28X5rQIuNVJKDCIpK6qftL
         AH3fraU+QBMwcieCGFOP9xxeeRyCGowDd57Psn4JbLH4njnZrUpJI2xraNz8MzagJk
         neyd/ejjj+r8w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBtYWtlcyBpdCBwb3NzaWJsZSB0byBpbmNsdWRlIG9yIGV4Y2x1ZGUgdGhlIENG
TQ0KPiBwcm90b2NvbCBhY2NvcmRpbmcgdG8gODAyLjFRIHNlY3Rpb24gMTIuMTQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVuZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3Jv
Y2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhvcmF0aXUudnVsdHVy
QG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgbmV0L2JyaWRnZS9LY29uZmlnICAgICAgfCAxMSAr
KysrKysrKysrKw0KPiAgbmV0L2JyaWRnZS9icl9kZXZpY2UuYyAgfCAgMyArKysNCj4gIG5ldC9i
cmlkZ2UvYnJfcHJpdmF0ZS5oIHwgIDMgKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDE3IGluc2Vy
dGlvbnMoKykNCj4gDQoNCkFja2VkLWJ5OiBOaWtvbGF5IEFsZWtzYW5kcm92IDxuaWtvbGF5QG52
aWRpYS5jb20+DQo=
