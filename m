Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9209B289B2F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389146AbgJIVuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:50:02 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:30424 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbgJIVuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 17:50:02 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80db060000>; Sat, 10 Oct 2020 05:49:58 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:49:53 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.50) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:49:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GD91HlJbEl9NYDWgptWscvinGSfdkY0X14vRPuWufaGTR/3aeJUdjS35fs7xsv+rfuJm7+6tNfBnUShko8565xsNqki4yRtcOUGX0mMx9vS1Y47PljrePDow0l5PmIqNsnmDjCp1T+qJcqjAvVwvUJxGlUJYibwHXs+axqJy9qSZm9PVv5rpZwq7GbadbY+o2pQanbFNzx6YbEWVwBna6xX0MGl/2gEnXDR8iRjPFY8GiGJDovddbRn1meNVHBeOfWUV2+SPtSuiao0INTsUaN7mfBOH00mpUlog0EJ3gIasWbW1ULCJT02xOFyMlai51mPsdztj/u6Cc2p+3W85Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jE3mpOQs7xCk0hccpDGeWls6q+9ixAr7njjTGhz+ZnM=;
 b=cdjHU6pwFBCY8IobKXxYmy79uGYVcqGg7R2GoBo7smUIsWrp/rHBJOqFmBgBrC7wdLNxDmtyQJZK+IKTJYvd+PqIBAEbMAC0/dTFAqXHGLWvBvjwI0orOtbLuwIa/HioWyVz4lawMVHdFlmN92G+m1cqnXVKgYooOpgNFDs1OG9MZADIyKnrIv+1POPTr68a4BwHgwDOdyn93rBI8YS8ONc1CzaqlAQTjHQP0dIdzfKltsT/naJiriZ9LNQCKQIPr3FAb0hR5V7lQGH2luMZQKkJqwaHG9MCR7QD9KcmBH6zie2p98G+VZvp5Ne1SEAHpg8xoDYvFl5aBKN6ihQmgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB4090.namprd12.prod.outlook.com (2603:10b6:5:217::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 9 Oct
 2020 21:49:51 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:49:51 +0000
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
Subject: Re: [PATCH net-next v4 05/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame TX added.
Thread-Topic: [PATCH net-next v4 05/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame TX added.
Thread-Index: AQHWnknaseyibku9cUuMN+0nHMhoDamPz6UA
Date:   Fri, 9 Oct 2020 21:49:51 +0000
Message-ID: <a091e766d38c00ef4d70b3bc003e16dc3747789b.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-6-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-6-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: cbc4568f-cc2e-4589-20ab-08d86c9d400d
x-ms-traffictypediagnostic: DM6PR12MB4090:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB40902A97763C30337A465333DF080@DM6PR12MB4090.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xWzhkDSpKElL5VmhdktPb6C9PuSNnwY5Cf4K0IT4HnQFCc1lOJPTmXH/bS8sSDp/bjoNrx4Tbflxi/PRE18vmz0xPt+FgceRyqDIEDJbZYyXC7hBtd/6YqNYlsAAKm0mgUMDdbZI91ipffHvOdBZtiVroCg5qIoL4kcsS/+TNI0GNELJhTRH4lSYoBx93sU6jDkqJCTKuo6xqPPtJF3zV4t5GgWpe92y7xXuq7XOBi94N/JPdNh2AL3BSiBTbs53hLQTFtTR9oqwt8UmGAXpkSQouCRi6n0Wm5zDpuObeQOMCz3TN7PMJJyA4+zBxd4inb7sd64Qlyj0lraG74obDAmcu+SNV7SR+MMeOGNkK0AGbCwaXuwC9s9n4/UQ3G3T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(110136005)(478600001)(36756003)(83380400001)(2906002)(186003)(8676002)(6512007)(5660300002)(71200400001)(8936002)(6506007)(76116006)(4326008)(86362001)(91956017)(66946007)(66556008)(64756008)(66476007)(66446008)(3450700001)(6486002)(26005)(316002)(2616005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 35NTURgAvV+ItKBtU6KcBAAJQjXJm5HBGfY/gKWYPgCMvYx0zfkNbKsE85AttWWEtXGBs4UFoo908ARuf0Cqw4zmBZAzMtTrRQKSwZhYuUVI/l6tlJWrPAK5LHRvA4p5ZzQOlt7em+le/Qb+X6zeunqBZTAEbOqzor+nSSXPMEILJRaA2hDsgt+gvtNNo8V2dqzTssDqvYAKeHj6P5+qvSIjNpxR8mDm67kV2VrsEyleIcwxv7obQX9r3RlCVDUcrGQoAxiBJE3ELKink2qvuQ5zKg4+92aYi0QwI0FpMJAjPW07QxxCqf2Y8sibAbzBZmYenjG9UQIril787OZESzFkytSJpZnTHOLr7+txbEE7Zw5KohDw9dOhxON57WPLe022mUxAXyqzPqoyCwg6BRb8ruAamFb4oGZ6CHb9R2XITjSbrnuMg8OIYr2kxTO2Hi6L2pfvPGazhBjhefzgrIhD3BS2TtWn3vWVVALOqGfrq+tFc/kVlQKDxihmlf8n+W5vyQc2Ud3v26uxMfFRo9LFilz8VitgrbM4WH/HRUy8zcBgsJa/5LeZrsQpTP2gib0k5ZKKZHLGNMoYroxUB3CK9pbHQK92oIaWRoOtu37fRUuihwyM7aa67en2I+BQjeACGKK53tBjhuhq4SCgaQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD7F611A7F75EC4E95D32E5F0D2A9E96@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc4568f-cc2e-4589-20ab-08d86c9d400d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:49:51.1603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cHFcYuh6n41+Mx2HLWb/+FjziuM+rdxqHJUxZLl+XAIuy67dWEZYCAnzCNV+YwHNINDgbgk205z7gWPoagbNgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4090
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280198; bh=jE3mpOQs7xCk0hccpDGeWls6q+9ixAr7njjTGhz+ZnM=;
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
        b=XobY/NaflLq0OLBq1GUooNgR6KkrunQ5OHiUTdpsXJ/rQhs1EcS9igyHdS8Hx+4RW
         ZHzCAEtuu0wchQ0AOkBtAHzCyfN3aBc/LjeUvkxtqgrmnA7LLMkgrtW3+HF4CzOq7s
         ij+4e9lTzKKBe+MD01QHAkqwMTOnXAfUzI2iIpbI/DEufQoTxjGZCFKY2hGB9r3XhH
         9Nq2hndeDOxEPOtnV0R/nQSJ0jtvqk1GWLdP33/g6K80a9tAinZ2vHz1akRO/OTFjJ
         FcvroYKVhHa5pvIXkl17DYye5fx10K3s2WiU1ttNM/p1A6mD23hsj0LwC2rtZjikwf
         c3oYF7jLeAmFw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgc2Vjb25kIGNvbW1pdCBvZiB0aGUgaW1wbGVtZW50YXRpb24gb2Yg
dGhlIENGTSBwcm90b2NvbA0KPiBhY2NvcmRpbmcgdG8gODAyLjFRIHNlY3Rpb24gMTIuMTQuDQo+
IA0KPiBGdW5jdGlvbmFsaXR5IGlzIGV4dGVuZGVkIHdpdGggQ0NNIGZyYW1lIHRyYW5zbWlzc2lv
bi4NCj4gDQo+IEludGVyZmFjZSBpcyBleHRlbmRlZCB3aXRoIHRoZXNlIGZ1bmN0aW9uczoNCj4g
YnJfY2ZtX2NjX3JkaV9zZXQoKQ0KPiBicl9jZm1fY2NfY2NtX3R4KCkNCj4gYnJfY2ZtX2NjX2Nv
bmZpZ19zZXQoKQ0KPiANCj4gQSBNRVAgQ29udGludWl0eSBDaGVjayBmZWF0dXJlIGNhbiBiZSBj
b25maWd1cmVkIGJ5DQo+IGJyX2NmbV9jY19jb25maWdfc2V0KCkNCj4gICAgIFRoZSBDb250aW51
aXR5IENoZWNrIHBhcmFtZXRlcnMgY2FuIGJlIGNvbmZpZ3VyZWQgdG8gYmUgdXNlZCB3aGVuDQo+
ICAgICB0cmFuc21pdHRpbmcgQ0NNLg0KPiANCj4gQSBNRVAgY2FuIGJlIGNvbmZpZ3VyZWQgdG8g
c3RhcnQgb3Igc3RvcCB0cmFuc21pc3Npb24gb2YgQ0NNIGZyYW1lcyBieQ0KPiBicl9jZm1fY2Nf
Y2NtX3R4KCkNCj4gICAgIFRoZSBDQ00gd2lsbCBiZSB0cmFuc21pdHRlZCBmb3IgYSBzZWxlY3Rl
ZCBwZXJpb2QgaW4gc2Vjb25kcy4NCj4gICAgIE11c3QgY2FsbCB0aGlzIGZ1bmN0aW9uIGJlZm9y
ZSB0aW1lb3V0IHRvIGtlZXAgdHJhbnNtaXNzaW9uIGFsaXZlLg0KPiANCj4gQSBNRVAgdHJhbnNt
aXR0aW5nIENDTSBjYW4gYmUgY29uZmlndXJlZCB3aXRoIGluc2VydGVkIFJESSBpbiBQRFUgYnkN
Cj4gYnJfY2ZtX2NjX3JkaV9zZXQoKQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGVucmlrIEJqb2Vy
bmx1bmQgIDxoZW5yaWsuYmpvZXJubHVuZEBtaWNyb2NoaXAuY29tPg0KPiBSZXZpZXdlZC1ieTog
SG9yYXRpdSBWdWx0dXIgIDxob3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPiAtLS0NCj4g
IGluY2x1ZGUvdWFwaS9saW51eC9jZm1fYnJpZGdlLmggfCAgMzkgKysrKy0NCj4gIG5ldC9icmlk
Z2UvYnJfY2ZtLmMgICAgICAgICAgICAgfCAyODQgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4gIG5ldC9icmlkZ2UvYnJfcHJpdmF0ZV9jZm0uaCAgICAgfCAgNTQgKysrKysrDQo+
ICAzIGZpbGVzIGNoYW5nZWQsIDM3NiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0K
DQpBY2tlZC1ieTogTmlrb2xheSBBbGVrc2FuZHJvdiA8bmlrb2xheUBudmlkaWEuY29tPg0KDQo=
